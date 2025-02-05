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
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Configurações do Chrome
chrome_options = Options()
chrome_options.add_argument('--ignore-certificate-errors')
chrome_options.add_argument('--ssl-version-min=tls1.2')
chrome_options.add_argument('--allow-insecure-localhost')
chrome_options.add_argument('--disable-extensions')
chrome_options.add_argument('--headless=new')
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')
chrome_options.add_argument("--disable-gpu")
chrome_options.add_argument("--disable-software-rasterizer")
chrome_options.add_argument("--disable-accelerated-2d-canvas")
chrome_options.add_argument("--disable-webgl")
chrome_options.add_argument("--use-gl=swiftshader")

def iniciar_driver():
    return webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)\
    
driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)
driver.set_script_timeout(300)
driver.set_page_load_timeout(120)

translator = Translator()

impact_translation = {
    "minor": "menor",
    "moderate": "moderado",
    "serious": "grave",
    "critical": "crítico"
}

def traduzir_nivel_impacto(nivel):
    return impact_translation.get(nivel, nivel)

def esperar_carregamento_completo():
    WebDriverWait(driver, 60).until(EC.presence_of_element_located((By.TAG_NAME, 'body')))

def traduzir_texto(texto):
    return texto

def esperar_carregamento_completo():
    try:
        WebDriverWait(driver, 60).until(EC.presence_of_element_located((By.TAG_NAME, 'body')))
    except Exception:
        print("Tempo limite atingido ao carregar a página. Pulando para a próxima.")
        raise TimeoutError("Tempo limite atingido ao carregar a página")
    
def verificar_driver():
    """ Verifica se o WebDriver está ativo e reinicia se necessário. """
    global driver
    try:
        # Testa se a sessão ainda está ativa tentando executar um script simples
        driver.execute_script("return document.readyState")  
        driver.title  
    except Exception:
        print("❌ Sessão inválida. Reiniciando WebDriver...")
        reiniciar_driver()



def testar_acessibilidade(url, tentativas=2):
    global driver
    print(f"Testando subdominio {url}")

    verificar_driver()

    try:
        if driver.session_id is None:
            print("Reiniciando o WebDriver...")
            reiniciar_driver()
        
        driver.get(url)
        esperar_carregamento_completo()
    except Exception as e:
            erro_str = str(e).lower()
            print(f"❌ Erro ao testar {url}: {e}")

            if "invalid session id" in erro_str or "session deleted" in erro_str:
                print("🔄 Reiniciando o WebDriver...")
                verificar_driver()

            if tentativa + 1 == tentativas:
                return {"erro": "Falha ao testar acessibilidade após múltiplas tentativas"}
    
    for tentativa in range(tentativas):
        try:
            driver.get(url)
            esperar_carregamento_completo()
            axe = Axe(driver)
            axe.inject()
            results = axe.run()

            total_testados = sum(len(violation["nodes"]) for violation in results.get("violations", []))
            total_testados += sum(len(passed["nodes"]) for passed in results.get("passes", []))

            if total_testados == 0:
                print(f"Nenhum elemento testado para {url}")
                return {"erro": "Nenhum elemento testado"}
            
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
        
        except TimeoutError:
            return {"erro": "Tempo limite atingido ao carregar a página"}
        except Exception as e:
            erro_str = str(e).lower()
            print(f"Erro ao testar {url}: {e}")

            if "invalid session id" in erro_str or "session deleted" in erro_str:
                print("Reiniciando o driver do Selenium...")
                driver.quit()
                time.sleep(5)
                driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)

            if tentativa + 1 == tentativas:
                return {"erro": "Falha ao testar acessibilidade após múltiplas tentativas"}

    return {"erro": "Erro inesperado"}


def reiniciar_driver():
    """ Reinicia o WebDriver do Selenium. """
    global driver
    print("🔄 Reiniciando o WebDriver...")
    try:
        driver.quit()
    except Exception:
        pass  # Ignora erros ao tentar fechar o driver

    time.sleep(5)  # Aguarda antes de reiniciar para evitar conflitos
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)
    driver.set_script_timeout(300)
    driver.set_page_load_timeout(120)


def carregar_relatorio_dominio(dominio, estado, municipio):

    caminho_arquivo = f'relatorios_dominios/relatorio_{municipio}.json'

    if os.path.exists(caminho_arquivo):
        try:
            with open(caminho_arquivo, 'r', encoding='utf-8') as f:
                return json.load(f)
        except json.JSONDecodeError:
            print(f"Erro ao carregar JSON do domínio {dominio}, arquivo corrompido. Criando novo...")

    return {"dominio": dominio, "estado": estado, "municipio": municipio, "subdominios": []}


def salvar_relatorio_dominio(dominio, relatorio_dominio):


    if not relatorio_dominio["subdominios"]:
        print(f"Relatório de {dominio} vazio.")
        return

    try:
        print(f"Enviando relatório para o domínio: {dominio} com {len(relatorio_dominio['subdominios'])} subdomínios.")
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

    total_linhas = len(df)

    for index, row in df.iterrows():
        dominio = row['DOMINIO']
        url_subdominio = row['URLS']
        estado = row['ESTADO']
        municipio = row['MUNICIPIO']
        status = row['STATUS AXE']
        data_extracao = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        if dominio_atual and dominio_atual != dominio:
            salvar_relatorio_dominio(dominio_atual, relatorio_atual)
            for idx, status_atualizado in buffer_status:
                df.at[idx, 'STATUS AXE'] = status_atualizado
            buffer_status.clear()
            df.to_excel('./insumo-bot-axe.xlsx', index=False)

        if dominio_atual != dominio:
            dominio_atual = dominio
            print(f"Processando domínio: {dominio} ({index + 1}/{total_linhas})")
            try:
                relatorio_atual = carregar_relatorio_dominio(dominio, estado, municipio)
            except Exception as ex:
                print(f"Erro ao carregar relatório para {dominio}: {ex}")
                buffer_status.append((index, 'JSON CORROMPIDO'))
                continue

        try:
            resultado = testar_acessibilidade(url_subdominio)
            if "erro" not in resultado:
                relatorio_atual["subdominios"].append(resultado)
                buffer_status.append((index, 'SUCESSO'))
            else:
                buffer_status.append((index, f'ERRO - {resultado["erro"]}'))
        except Exception as e:
            buffer_status.append((index, f'ERRO - {str(e)}'))

        df['DATA TESTE AXE'] = df['DATA TESTE AXE'].astype(str)  # Converte toda a coluna para string
        if num_urls_processadas % 30 == 0:
            criar_backup('./insumo-bot-axe.xlsx')
        elapsed_time = time.time() - start_time
        if elapsed_time >= 3600:
            print("Dormindo após uma hora....")
            time.sleep(10)
            start_time = time.time()

    if dominio_atual:
        salvar_relatorio_dominio(dominio_atual, relatorio_atual)

processar_dominios()

driver.quit()
print('Nenhuma URL a ser processada' if num_urls_processadas == 0 else f'Foram processadas {num_urls_processadas} URLs')
