import json
import os
import pandas as pd
from axe_selenium_python import Axe
from selenium.webdriver.chrome.options import Options
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from googletrans import Translator
from datetime import datetime
import time
import re
import shutil
import requests


chrome_options = Options()
chrome_options.add_argument('--ignore-certificate-errors')
chrome_options.add_argument('--ssl-version-min=tls1.2')
chrome_options.add_argument('--allow-insecure-localhost')
# chrome_options.add_argument('--blink-settings=imagesEnabled=false')
# chrome_options.add_argument('--disable-javascript')
chrome_options.add_argument('--disable-extensions')
chrome_options.add_argument('--headless=new')
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')
# chrome_options.add_argument('--disable-features=ScriptStreaming')



driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)
driver.set_script_timeout(300)
driver.set_page_load_timeout(120)


translator = Translator()


def traduzir_texto(texto):
    return texto

impact_translation = {
    "minor": "menor",
    "moderate": "moderado",
    "serious": "grave",
    "critical": "crítico"
}

def traduzir_nivel_impacto(nivel):
    return impact_translation.get(nivel, nivel)


def testar_acessibilidade(url):
    try:
        driver.get(url)
    except Exception as e:
        print(f"Erro ao carregar a página {url}: {e}")
        return {"erro": "Timeout ao carregar a página"}
    axe = Axe(driver)
    axe.inject()
    results = axe.run()
    total_testados = sum(len(violation["nodes"]) for violation in results.get("violations", []))
    total_testados += sum(len(passed["nodes"]) for passed in results.get("passes", []))
    relatorio = {
        "url": url,
        "total_elementos_testados": total_testados,
        "violacoes": []
    }
    for violation in results["violations"]:
        violacao_data = {
            "violacao": traduzir_texto(violation['description']),
            "regra_violada": violation['id'],
            "como_corrigir": traduzir_texto(violation['help']),
            "mais_informacoes": violation['helpUrl'],
            "nivel_impacto": traduzir_nivel_impacto(violation['impact']),
            "elementos_afetados": []
        }
        for node in violation["nodes"]:
            violacao_data["elementos_afetados"].append({
                "elemento_html": node['html'],
                "selectores": node['target'],
                "texto_contexto": traduzir_texto(node['failureSummary'])
            })
        relatorio["violacoes"].append(violacao_data)
    return relatorio


def carregar_relatorio_dominio(dominio, estado, municipio):
    dominio_sanitizado = re.sub(r'[^\w\-]', '_', dominio)
    caminho_arquivo = f'relatorios_dominios/relatorio_{dominio_sanitizado}.json'
    if os.path.exists(caminho_arquivo):
        with open(caminho_arquivo, 'r', encoding='utf-8') as f:
            return json.load(f)
    return {"dominio": dominio, "estado":estado, "municipio": municipio, "subdominios": []}


def salvar_relatorio_dominio(dominio, relatorio_dominio):
    # Salva o relatório localmente primeiro
    dominio_sanitizado = re.sub(r'[^\w\-]', '_', dominio)
    caminho_arquivo = f'relatorios_dominios/relatorio_{dominio_sanitizado}.json'
    
    try:
        # Criar diretório, se necessário
        os.makedirs(os.path.dirname(caminho_arquivo), exist_ok=True)

        # Salvar o JSON no arquivo local
        with open(caminho_arquivo, 'w', encoding='utf-8') as f:
            json.dump(relatorio_dominio, f, ensure_ascii=False, indent=4)
        print(f"Relatório salvo localmente em: {caminho_arquivo}")
    except Exception as e:
        print(f"Erro ao salvar relatório localmente para {dominio}: {e}")
        registrar_erro_api(dominio)
    
    # Enviar relatório para a API
    try:
        print("=== Relatório de Domínio a ser Enviado ===")
        print(f"Fazendo post para a API para o domínio: {dominio}")
        response = requests.post(
            'http://localhost:3001/api/domains',
            json=relatorio_dominio
        )
        if response.status_code == 201:
            print(f"Relatório enviado com sucesso para o domínio: {dominio}")
        else:
            print(f"Falha ao enviar o relatório para {dominio}. Status Code: {response.status_code}")
            registrar_erro_api(dominio)
    except Exception as e:
        print(f"Erro ao enviar relatório para {dominio}: {e}")
        registrar_erro_api(dominio)




def registrar_erro_api(dominio):
    try:
        with open('errosApi.txt', 'a', encoding='utf-8') as f:
            f.write(f"{dominio}\n")
        print(f"Domínio registrado em errosApi.txt: {dominio}")
    except Exception as e:
        print(f"Erro ao registrar o domínio em errosApi.txt: {e}")




def criar_backup(nome_arquivo):
    nome_backup = nome_arquivo.replace('.xlsx', '-backup.xlsx')
    try:
        shutil.copy(nome_arquivo, nome_backup)
        print(f"Backup criado: {nome_backup}")
    except Exception as e:
        print(f"Erro ao criar backup: {e}")




df = pd.read_excel('./insumo-bot-axe.xlsx')
df['STATUS AXE'] = df['STATUS AXE'].astype(str)


num_urls_processadas = 0
dominio_atual = None
relatorio_atual = None
buffer_status = []
start_time = time.time()


def processar_dominios():
    global dominio_atual, relatorio_atual, buffer_status, num_urls_processadas, start_time

    for index, row in df.iterrows():
        dominio = row['DOMINIO']
        url_subdominio = row['URLS']
        estado = row['ESTADO']
        municipio = row['MUNICIPIO']
        status = row['STATUS AXE']
        data_extracao = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        print(f"Processando subdomínio {index + 1}/{len(df)}  -  {url_subdominio} - {municipio}")

        if dominio_atual and dominio_atual != dominio:
            salvar_relatorio_dominio(dominio_atual, relatorio_atual)
            for idx, status_atualizado in buffer_status:
                df.at[idx, 'STATUS AXE'] = status_atualizado
            buffer_status.clear()
            df.to_excel('./insumo-bot-axe.xlsx', index=False)

        if dominio_atual != dominio:
            dominio_atual = dominio
            try:
                relatorio_atual = carregar_relatorio_dominio(dominio, estado, municipio)
            except Exception as ex:
                print(f"Json corrompido para o subdomínio {url_subdominio}: {ex}")
                buffer_status.append((index, 'JSON CORROMPIDO'))
                continue

        if 1 == 1:
            time.sleep(2)
            num_urls_processadas += 1
            try:
                resultado = testar_acessibilidade(url_subdominio)
                relatorio_atual["subdominios"].append(resultado)
                buffer_status.append((index, 'SUCESSO'))
            except Exception as e:
                print(f"Erro ao processar o subdomínio {url_subdominio}: {e}")
                error_message = str(e)
                buffer_status.append((index, f'ERRO - {error_message}'))

            df.at[index, 'DATA TESTE AXE'] = data_extracao

            if num_urls_processadas % 30 == 0:
                criar_backup('./insumo-bot-axe.xlsx')

            elapsed_time = time.time() - start_time
            # if elapsed_time >= 3600:
            #     print("Dormindo após uma hora....")
            #     time.sleep(6000)
            #     start_time = time.time()

    if dominio_atual:
        salvar_relatorio_dominio(dominio_atual, relatorio_atual)
        for idx, status_atualizado in buffer_status:
            df.at[idx, 'STATUS AXE'] = status_atualizado
        df.to_excel('./insumo-bot-axe.xlsx', index=False)

processar_dominios()

driver.quit()
print('Nenhuma URL a ser processada' if num_urls_processadas == 0 else f'Foram processadas {num_urls_processadas} URLs')