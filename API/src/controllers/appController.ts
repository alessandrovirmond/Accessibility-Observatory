import { Request, Response } from 'express';
import { Pool } from 'mysql2/promise';
import { writeFileSync, readFileSync, existsSync } from 'fs';
import { join } from 'path';

export class DomainController {
  private db: Pool;
  private DATE_FILE_PATH = join(__dirname, 'date.json');

  constructor(db: Pool) {
    this.db = db;
  }

  async saveDomain(req: Request, res: Response): Promise<void> {
    const { dominio, subdominios, estado, municipio } = req.body;


    // Exibindo as quantidades recebidas
    console.log(`Quantidade de subdomínios recebidos para o domínio "${dominio}":`, subdominios.length);

    const connection = await this.db.getConnection();
    await connection.beginTransaction();

    try {
        // Verifica se o domínio já existe
        const [existingDomain] = await connection.execute(
            'SELECT id FROM dominio WHERE url = ?',
            [dominio]
        );

        if ((existingDomain as any).length > 0) {
            console.log('Domínio já existe. Deletando domínio e dados relacionados automaticamente.');

            // O banco de dados cuidará da exclusão das entradas relacionadas devido ao ON DELETE CASCADE
            const dominioId = (existingDomain as any)[0].id;

            // Deletando o domínio, que causará a exclusão de subdomínios, violações e elementos afetados automaticamente
            await connection.execute('DELETE FROM dominio WHERE id = ?', [dominioId]);
            console.log('Domínio e dados relacionados deletados automaticamente.');
        }

        // Inserir o novo domínio com estado e município

        const [domainResult] = await connection.execute(
            'INSERT INTO dominio (url, estado, municipio) VALUES (?, ?, ?)',
            [dominio, estado, municipio]
        );
        const dominioId = (domainResult as any).insertId;
        

        // Inserir subdomínios
        for (const subdominio of subdominios) {
            const { url, total_elementos_testados, violacoes } = subdominio;

            if (!url) continue;
          
         
            const [existingSubdomain] = await connection.execute(
                'SELECT id FROM subdominio WHERE url = ? AND dominio_id = ?',
                [url, dominioId]
            );

            if ((existingSubdomain as any).length > 0) {
                console.log(`Subdomínio "${url}" já existe. Ignorando.`);
                continue; // Pular para o próximo subdomínio
            }

   
            const nota = this.calcularNotaSubdominio({
                violacoes,
                total_elementos_testados,
            });

            const [subdomainResult] = await connection.execute(
                'INSERT INTO subdominio (url, nota, total_elementos_testados, dominio_id) VALUES (?, ?, ?, ?)',
                [url, nota, total_elementos_testados, dominioId]
            );
            const subdominioId = (subdomainResult as any).insertId;
      

            // Inserir violações
            for (const violacao of violacoes) {
                const {
                    violacao: descricaoViolacao,
                    regra_violada,
                    como_corrigir,
                    mais_informacoes,
                    nivel_impacto,
                    elementos_afetados,
                } = violacao;

                const [violationResult] = await connection.execute(
                    'INSERT INTO violacao (descricao, regra_violada, como_corrigir, mais_informacoes, nivel_impacto, subdominio_id) VALUES (?, ?, ?, ?, ?, ?)',
                    [
                        descricaoViolacao,
                        regra_violada,
                        como_corrigir,
                        mais_informacoes,
                        nivel_impacto,
                        subdominioId,
                    ]
                );
                const violacaoId = (violationResult as any).insertId;

                // Inserir elementos afetados
                for (const elemento of elementos_afetados) {
                    const { elemento_html, selectores, texto_contexto } = elemento;

                    await connection.execute(
                        'INSERT INTO elemento_afetado (elemento_html, selectores, texto_contexto, violacao_id) VALUES (?, ?, ?, ?)',
                        [
                            elemento_html,
                            JSON.stringify(selectores),
                            texto_contexto,
                            violacaoId,
                        ]
                    );
                }
            }
        }

        await connection.commit();
        console.log('Transação concluída com sucesso.');
        res.status(201).send({ message: 'Domínio salvo com sucesso!' });
    } catch (error) {
        await connection.rollback();
        console.error('Erro ao salvar domínio:', error);
        res.status(500).send({ message: 'Erro ao salvar domínio.' });
    } finally {
        connection.release();
    }
}


  
  

  calcularNotaSubdominio(subdominio: any): number {
    const PESO_IMPACTO: Record<'crítico' | 'grave' | 'moderado' | 'menor', number> = {
      crítico: 7,
      grave: 5,
      moderado: 3,
      menor: 2,
    };
    const K = 10; // Fator de normalização

    let severidadeTotal = 0;
    const violacoes = subdominio.violacoes || [];
    const totalElementosTestados = subdominio.total_elementos_testados || 0;

    for (const violacao of violacoes) {
      const nivelImpacto = (violacao.nivel_impacto || '').toLowerCase() as keyof typeof PESO_IMPACTO;

      const peso = PESO_IMPACTO[nivelImpacto] || 0;

      const elementosAfetados = violacao.elementos_afetados || [];
      const quantidadeElementosAfetados = elementosAfetados.length;

      const porcentagemAfetada =
        totalElementosTestados > 0
          ? quantidadeElementosAfetados / totalElementosTestados
          : 0;

      severidadeTotal += peso * porcentagemAfetada;
    }

    // Calcula a nota como número decimal
    const nota = Math.max(1, 10 - severidadeTotal * K);


    // Retorna o valor como um número decimal
    return parseFloat(nota.toFixed(2));
  }


  
  async getAllDomains(req: Request, res: Response) {
    console.warn('Requisição para obter todos os domínios recebida.');
    try {
      const query = `
        SELECT 
          d.id AS dominio_id,
          d.url AS dominio,
          d.estado,
          d.municipio,
          COUNT(DISTINCT s.id) AS total_paginas,
          COALESCE(SUM(v.total_violacoes), 0) AS total_violacoes,
          CASE 
            WHEN COUNT(DISTINCT s.id) > 0 THEN COALESCE(SUM(v.total_violacoes), 0) / COUNT(DISTINCT s.id)
            ELSE 0 
          END AS media_violacoes_por_pagina,
          CASE 
            WHEN COUNT(DISTINCT s.id) > 0 THEN COALESCE(SUM(e.total_elementos_afetados), 0) / COUNT(DISTINCT s.id)
            ELSE 0 
          END AS media_elementos_afetados_por_pagina,
          COALESCE(AVG(s.nota), 0) AS nota_dominio
        FROM dominio d
        LEFT JOIN subdominio s ON s.dominio_id = d.id
        LEFT JOIN (
          SELECT 
            subdominio_id,
            COUNT(*) AS total_violacoes
          FROM violacao
          GROUP BY subdominio_id
        ) v ON v.subdominio_id = s.id
        LEFT JOIN (
          SELECT 
            v.subdominio_id,
            COUNT(*) AS total_elementos_afetados
          FROM elemento_afetado e
          INNER JOIN violacao v ON e.violacao_id = v.id
          GROUP BY v.subdominio_id
        ) e ON e.subdominio_id = s.id
        GROUP BY d.id, d.url, d.estado, d.municipio
        ORDER BY nota_dominio DESC;
      `;
  
      const [domains] = await this.db.execute(query);
  
      res.status(200).json({ data: domains });
    } catch (error) {
      console.error('Erro ao obter os domínios:', error);
      res.status(500).send({ message: 'Erro ao obter os domínios.' });
    }
  }
  
  


  async getSubdomainByDomainId(req: Request, res: Response) {
    const id = Number(req.params.id);
    try {
      // SQL modificado para incluir as informações adicionais
      const [subdomains] = await this.db.execute(
        `SELECT 
        s.id AS subdominio_id,
        s.url AS subdominio_url,
        CAST(s.nota AS DECIMAL(10,2)) AS subdominio_nota,  -- Garantindo que a nota seja retornada como número
        COUNT(DISTINCT v.id) AS violacoes,
        COUNT(DISTINCT e.id) AS elementos_afetados,
        s.total_elementos_testados AS elementosTestados
      FROM 
        subdominio s
      LEFT JOIN violacao v ON v.subdominio_id = s.id
      LEFT JOIN elemento_afetado e ON e.violacao_id = v.id
      WHERE 
        s.dominio_id = ?
      GROUP BY 
        s.id;
      `,
        [id]
      );

      
      // Retorna os dados dentro de uma chave 'data'
      res.status(200).json({ data: subdomains });
    } catch (error) {
      console.error('Erro ao obter os subdomínios:', error);
      res.status(500).send({ message: 'Erro ao obter os subdomínios.' });
    }
  }
  

  async getViolationsBySubdomainId(req: Request, res: Response) {
    const id = Number(req.params.id);
    console.warn('Requisição para obter violações do subdomínio com ID:', id);
    try {
      // SQL modificado para incluir os campos desejados e a contagem de elementos afetados
      const [violations] = await this.db.execute(
        `SELECT 
  v.id AS "id",
  v.descricao AS "violacao",
  v.regra_violada AS "regra_violada",
  v.como_corrigir AS "como_corrigir",
  v.mais_informacoes AS "mais_informacoes",  -- Faltava a aspas de fechamento aqui
  v.nivel_impacto AS "nivel_impacto",
  COUNT(DISTINCT e.id) AS "elementos_afetados"
FROM 
  violacao v
LEFT JOIN elemento_afetado e ON e.violacao_id = v.id
WHERE 
  v.subdominio_id = ?
GROUP BY 
  v.id;
`,
        [id]
      );
      
      console.warn('Violações recuperadas com sucesso:', violations);
      
      // Retorna os dados dentro da chave 'data'
      res.status(200).json({ data: violations });
    } catch (error) {
      console.error('Erro ao obter violações:', error);
      res.status(500).send({ message: 'Erro ao obter violações.' });
    }
  }
  
  async getTop10Domains(req: Request, res: Response) {
    console.warn('Requisição para obter os 10 principais domínios recebida.');
    try {
        const query = `
            SELECT 
                d.id AS dominio_id,
                d.url AS dominio,
                d.estado,
                d.municipio,
                COUNT(DISTINCT s.id) AS total_paginas,
                COALESCE(SUM(v.total_violacoes), 0) AS total_violacoes,
                CASE 
                    WHEN COUNT(DISTINCT s.id) > 0 THEN COALESCE(SUM(v.total_violacoes), 0) / COUNT(DISTINCT s.id)
                    ELSE 0 
                END AS media_violacoes_por_pagina,
                CASE 
                    WHEN COUNT(DISTINCT s.id) > 0 THEN COALESCE(SUM(e.total_elementos_afetados), 0) / COUNT(DISTINCT s.id)
                    ELSE 0 
                END AS media_elementos_afetados_por_pagina,
                COALESCE(AVG(s.nota), 0) AS nota_dominio
            FROM dominio d
            LEFT JOIN subdominio s ON s.dominio_id = d.id
            LEFT JOIN (
                SELECT 
                    subdominio_id,
                    COUNT(*) AS total_violacoes
                FROM violacao
                GROUP BY subdominio_id
            ) v ON v.subdominio_id = s.id
            LEFT JOIN (
                SELECT 
                    v.subdominio_id,
                    COUNT(*) AS total_elementos_afetados
                FROM elemento_afetado e
                INNER JOIN violacao v ON e.violacao_id = v.id
                GROUP BY v.subdominio_id
            ) e ON e.subdominio_id = s.id
            GROUP BY d.id, d.url, d.estado, d.municipio
            ORDER BY nota_dominio DESC
            LIMIT 10;
        `;

        const [domains] = await this.db.execute(query);

        res.status(200).json({ data: domains });
    } catch (error) {
        console.error('Erro ao obter os domínios:', error);
        res.status(500).send({ message: 'Erro ao obter os domínios.' });
    }
}

async getTop10DomainsByState(req: Request, res: Response) {
    let { state } = req.params;
    state = state.replace(/_/g, ' ');

    console.warn(`Requisição para obter os 10 principais domínios do estado: ${state}`);

    try {
        const query = `
            SELECT 
                d.id AS dominio_id,
                d.url AS dominio,
                d.estado,
                d.municipio,
                COUNT(DISTINCT s.id) AS total_paginas,
                COALESCE(SUM(v.total_violacoes), 0) AS total_violacoes,
                COALESCE(SUM(v.total_violacoes) / COUNT(DISTINCT s.id), 0) AS media_violacoes_por_pagina,
                COALESCE(SUM(e.total_elementos_afetados) / COUNT(DISTINCT s.id), 0) AS media_elementos_afetados_por_pagina,
                COALESCE(AVG(s.nota), 0) AS nota_dominio
            FROM dominio d
            LEFT JOIN subdominio s ON s.dominio_id = d.id
            LEFT JOIN (
                SELECT 
                    subdominio_id,
                    COUNT(*) AS total_violacoes
                FROM violacao
                GROUP BY subdominio_id
            ) v ON v.subdominio_id = s.id
            LEFT JOIN (
                SELECT 
                    v.subdominio_id,
                    COUNT(*) AS total_elementos_afetados
                FROM elemento_afetado e
                INNER JOIN violacao v ON e.violacao_id = v.id
                GROUP BY v.subdominio_id
            ) e ON e.subdominio_id = s.id
            WHERE d.estado = ?
            GROUP BY d.id, d.url, d.estado, d.municipio
            ORDER BY nota_dominio DESC
            LIMIT 10;
        `;

        const [domains] = await this.db.execute(query, [state]);

        res.status(200).json({ data: domains });
    } catch (error) {
        console.error('Erro ao obter domínios por estado:', error);
        res.status(500).send({ message: 'Erro ao obter domínios por estado.' });
    }
}


  async getElementsByViolationId(req: Request, res: Response) {
    const id = Number(req.params.id);
    console.warn('Requisição para obter elementos da violação com ID:', id);
    try {
      const [elements] = await this.db.execute(
        'SELECT * FROM elemento_afetado WHERE violacao_id = ?',
        [id]
      );

  
      // Retorna os dados dentro de uma chave 'data'
      res.status(200).json({ data: elements });
    } catch (error) {
      console.error('Erro ao obter elementos:', error);
      res.status(500).send({ message: 'Erro ao obter elementos.' });
    }
  }

  async getDomainByState(req: Request, res: Response) {
    let { state } = req.params;
    state = state.replace(/_/g, ' ');
  
    console.warn(`Requisição para obter domínios do estado: ${state}`);
  
    try {
      const query = `
        SELECT 
          d.id AS dominio_id,
          d.url AS dominio,
          d.estado,
          d.municipio,
          COUNT(DISTINCT s.id) AS total_paginas,
          COALESCE(SUM(v.total_violacoes), 0) AS total_violacoes,
          COALESCE(SUM(v.total_violacoes) / COUNT(DISTINCT s.id), 0) AS media_violacoes_por_pagina,
          COALESCE(SUM(e.total_elementos_afetados) / COUNT(DISTINCT s.id), 0) AS media_elementos_afetados_por_pagina,
          COALESCE(AVG(s.nota), 0) AS nota_dominio
        FROM dominio d
        LEFT JOIN subdominio s ON s.dominio_id = d.id
        LEFT JOIN (
          SELECT 
            subdominio_id,
            COUNT(*) AS total_violacoes
          FROM violacao
          GROUP BY subdominio_id
        ) v ON v.subdominio_id = s.id
        LEFT JOIN (
          SELECT 
            v.subdominio_id,
            COUNT(*) AS total_elementos_afetados
          FROM elemento_afetado e
          INNER JOIN violacao v ON e.violacao_id = v.id
          GROUP BY v.subdominio_id
        ) e ON e.subdominio_id = s.id
        WHERE d.estado = ?
        GROUP BY d.id, d.url, d.estado, d.municipio
        ORDER BY nota_dominio DESC;
      `;
  
      const [domains] = await this.db.execute(query, [state]);
  
      res.status(200).json({ data: domains });
    } catch (error) {
      console.error('Erro ao obter domínios por estado:', error);
      res.status(500).send({ message: 'Erro ao obter domínios por estado.' });
    }
  }


  

  async getStates(req: Request, res: Response) {
    console.warn('Requisição para obter todos os estados distintos');
  
    try {
      const query = `
        SELECT DISTINCT estado
        FROM dominio
        WHERE estado IS NOT NULL AND estado != ''
        ORDER BY estado ASC;
      `;
  
      const [rows] = await this.db.execute(query);
  
      // Verifica se a consulta retornou resultados e acessa a propriedade 'rows'
      if (Array.isArray(rows)) {
        const estadoList = rows.map((row: any) => row.estado); // Aqui acessa 'estado' de cada linha
        res.status(200).json({ data: estadoList });
      } else {
        res.status(500).send({ message: 'Erro ao processar os dados.' });
      }
  
    } catch (error) {
      console.error('Erro ao obter estados distintos:', error);
      res.status(500).send({ message: 'Erro ao obter estados distintos.' });
    }
  }
  
  async getDate(req: Request, res: Response) {
    try {
      const query = `
        SHOW TABLE STATUS FROM observatorio LIKE 'dominio';
      `;
  
      const [rows]: any = await this.db.execute(query);
  
      // Verifica se existem dados na resposta e obtém a data de atualização
      const updateTime = rows?.[0]?.Update_time || null;
  
      res.status(200).json({ data: updateTime });
    } catch (error) {
      console.error('Erro ao obter a data de atualização:', error);
      res.status(500).send({ message: 'Erro ao obter a data de atualização.' });
    }
  }  
}