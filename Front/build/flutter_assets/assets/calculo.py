import json

# Definindo pesos para os níveis de impacto
PESO_IMPACTO = {
    "crítico": 7,
    "grave": 5,
    "moderado": 3,
    "menor": 1
}

# Valor de normalização K para ajustar a escala da nota final
K = 10

def calcular_nota_acessibilidade(caminho_arquivo_json):
    # Carrega o JSON do arquivo
    with open(caminho_arquivo_json, 'r', encoding='utf-8') as f:
        dados = json.load(f)
    
    # Itera sobre cada domínio no JSON
    for dominio, info in dados.items():
        print(f"\n=========================================")
        print(f"Calculando notas para o domínio: {dominio}")
        print(f"=========================================")
        
        subdominios = info.get("subdominios", [])
        notas_subdominios = []
        total_violacoes_dominio = 0
        total_elementos_afetados_dominio = 0
        total_elementos_testados_dominio = 0
        
        # Calcula a nota de cada Página
        for subdominio in subdominios:
            severidade_total = 0
            violacoes = subdominio.get("violacoes", [])
            total_violacoes_subdominio = len(violacoes)
            total_elementos_afetados_subdominio = 0
            total_elementos_testados = subdominio.get("total_elementos_testados", 0)
            
            for violacao in violacoes:
                # Obtem o peso do impacto
                nivel_impacto = violacao.get("nivel_impacto", "").lower()
                peso = PESO_IMPACTO.get(nivel_impacto, 0)

                # Calcula a porcentagem de elementos afetados
                elementos_afetados = violacao.get("elementos_afetados", [])
                quantidade_elementos_afetados = len(elementos_afetados)
                
                if total_elementos_testados > 0:
                    porcentagem_afetada = quantidade_elementos_afetados / total_elementos_testados
                else:
                    porcentagem_afetada = 0

                # Calcula a severidade da violacao com base no peso e na porcentagem de elementos afetados
                severidade_violacao = peso * porcentagem_afetada
                total_elementos_afetados_subdominio += quantidade_elementos_afetados
                
                # Soma a severidade da violacao à severidade total do Página
                severidade_total += severidade_violacao
            
            # Atualiza os totais para o domínio
            total_violacoes_dominio += total_violacoes_subdominio
            total_elementos_afetados_dominio += total_elementos_afetados_subdominio
            total_elementos_testados_dominio += total_elementos_testados
            
            # Calcula a nota do Página
            nota_subdominio = max(1, 10 - (severidade_total * K))
            notas_subdominios.append(nota_subdominio)
            
            # Exibe os detalhes do Página
            print(f"\nPágina: {subdominio.get('url', 'Desconhecido')}")
            print(f"  - Nota: {round(nota_subdominio, 2)}")
            print(f"  - Violações: {total_violacoes_subdominio}")
            print(f"  - Elementos Afetados: {total_elementos_afetados_subdominio}")
            print(f"  - Total Elementos Testados: {total_elementos_testados}")
        
        # Calcula a nota do domínio como a média das notas de suas páginas
        nota_dominio = sum(notas_subdominios) / len(notas_subdominios) if notas_subdominios else 1
        
        # Calcula métricas adicionais para o domínio
        media_violacoes_por_pagina = total_violacoes_dominio / len(subdominios) if subdominios else 0
        media_elementos_afetados_por_pagina = total_elementos_afetados_dominio / len(subdominios) if subdominios else 0
        media_elementos_testados_por_pagina = total_elementos_testados_dominio / len(subdominios) if subdominios else 0
        
        # Exibe os detalhes do domínio
        print(f"\n-----------------------------------------")
        print(f"Resumo do domínio: {dominio}")
        print(f"  - Nota: {round(nota_dominio, 2)}")
        print(f"  - Total de páginas: {len(subdominios)}")
        print(f"  - Total de violações: {total_violacoes_dominio}")
        print(f"  - Média de violações por página: {round(media_violacoes_por_pagina, 2)}")
        print(f"  - Média de elementos afetados por página: {round(media_elementos_afetados_por_pagina, 2)}")
        print(f"  - Média de elementos testados por página: {round(media_elementos_testados_por_pagina, 2)}")
        print(f"=========================================")

# Caminho do arquivo JSON
caminho_arquivo_json = 'relatorio_acessibilidade.json'

# Calcula e exibe as notas de acessibilidade
calcular_nota_acessibilidade(caminho_arquivo_json)
