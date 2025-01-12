import { Request, Response } from 'express';
import { Pool } from 'mysql2/promise'; // Supondo que você está usando mysql2 com Promises

export class DomainController {
  private db: Pool;

  constructor(db: Pool) {
    this.db = db;
  }

  async saveDomain(req: Request, res: Response): Promise<void> {
    const { dominio, subdominios } = req.body;

    if (!dominio || !subdominios || !Array.isArray(subdominios)) {
      res.status(400).send({ message: 'Formato de JSON inválido.' });
      return;
    }

    const connection = await this.db.getConnection();
    await connection.beginTransaction();

    try {
      const [domainResult] = await connection.execute(
        `INSERT INTO dominio (url) VALUES (?)`,
        [dominio]
      );
      const dominioId = (domainResult as any).insertId;

      for (const subdominio of subdominios) {
        const { url, total_elementos_testados, violacoes } = subdominio;

        const [subdomainResult] = await connection.execute(
          `INSERT INTO subdominio (url, total_elementos_testados, dominio_id) VALUES (?, ?, ?)`,
          [url, total_elementos_testados, dominioId]
        );
        const subdominioId = (subdomainResult as any).insertId;

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
            `INSERT INTO violacao (descricao, regra_violada, como_corrigir, mais_informacoes, nivel_impacto, subdominio_id) VALUES (?, ?, ?, ?, ?, ?)`,
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

          for (const elemento of elementos_afetados) {
            const { elemento_html, selectores, texto_contexto } = elemento;

            await connection.execute(
              `INSERT INTO elemento_afetado (elemento_html, selectores, texto_contexto, violacao_id) VALUES (?, ?, ?, ?)`,
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
      res.status(201).send({ message: 'Domínio salvo com sucesso!' });
    } catch (error) {
      await connection.rollback();
      console.error('Erro ao salvar domínio:', error);
      res.status(500).send({ message: 'Erro ao salvar domínio.' });
    } finally {
      connection.release();
    }
  }
}
