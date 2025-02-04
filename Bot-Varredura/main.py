import time
import pandas as pd
import os
from selenium.webdriver.chrome.options import Options
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.common.exceptions import TimeoutException, StaleElementReferenceException, WebDriverException
from webdriver_manager.chrome import ChromeDriverManager
import keyboard
from datetime import datetime

# Configuração do Selenium
chrome_options = Options()
chrome_options.add_argument('--ignore-certificate-errors')
chrome_options.add_argument('--ssl-version-min=tls1.2')
chrome_options.add_argument('--allow-insecure-localhost')
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')
chrome_options.add_argument('--disable-gpu')
chrome_options.add_argument("--enable-unsafe-webgl")
chrome_options.add_argument("--disable-software-rasterizer")
chrome_options.add_argument("--use-gl=desktop")
chrome_options.add_argument("--use-gl=swiftshader")
chrome_options.add_argument('--headless=new')  # Mantém o modo headless ativado
chrome_options.add_argument('--use-gl=swiftshader') 



# Inicializa o WebDriver
try:
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)
except WebDriverException as e:
    print("Erro ao iniciar o WebDriver:", e)
    exit()

def esperar_carregamento_completo(driver, timeout=50):
    """Aguarda a página carregar completamente verificando document.readyState e a presença de links."""
    try:
        # Aguarda até que a página esteja completamente carregada
        WebDriverWait(driver, timeout).until(
            lambda d: d.execute_script("return document.readyState") == "complete"
        )
        
        # Tempo extra para carregamento dinâmico (JavaScript)
        time.sleep(5)  # Ajuste conforme necessário

    except TimeoutException:
        print("⚠️ Aviso: Tempo limite excedido ao carregar a página.")



def extrair_subpaginas(domain):
    domain = domain.strip()
    full_url = "https://www." + domain
    print(f"Acessando: {full_url}")

    try:
        driver.get(full_url)
        esperar_carregamento_completo(driver)  # Usa a nova função de espera
    except WebDriverException as e:
        print(f"❌ Erro ao acessar {full_url}: {e}")
        return set()

    try:
        links = WebDriverWait(driver, 15).until(EC.presence_of_all_elements_located((By.TAG_NAME, 'a')))
    except TimeoutException:
        print(f"⚠️ Nenhum link encontrado em {full_url}.")
        return set()

    subpaginas = set()
    keywords_to_exclude = ["/#", "mailto:", "@"]

    for link in links:
        try:
            href = link.get_attribute("href")
            if href and domain in href:
                if href.endswith(('png', 'jpg', 'jpeg', 'gif', 'bmp', 'svg', 'webp', 'pdf', 'docx', 'pptx')) or any(keyword in href for keyword in keywords_to_exclude):
                    continue
                subpaginas.add(href)
        except StaleElementReferenceException:
            continue  # Ignora elementos obsoletos

    return subpaginas


def salvar_subpaginas_excel(pagina, subpaginas, estado, municipio):
    caminho_arquivo = '../Bot-AxeDevTools/insumo-bot-axe.xlsx'
    data_extracao = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    if os.path.exists(caminho_arquivo):
        df_existente = pd.read_excel(caminho_arquivo)
    else:
        df_existente = pd.DataFrame(columns=['DOMINIO', 'URLS', 'DATA EXTRACAO', 'STATUS AXE', 'DATA TESTE AXE', 'ESTADO', 'MUNICIPIO'])
    
    df_existente = df_existente[df_existente['DOMINIO'] != pagina]
    
    novos_dados = pd.DataFrame({
        'DOMINIO': [pagina] * len(subpaginas),
        'URLS': list(subpaginas),
        'DATA EXTRACAO': data_extracao,
        'ESTADO': estado,
        'MUNICIPIO': municipio,
    })
    
    print(f"{len(subpaginas)} URLs extraídas de {pagina} ({municipio})")
    df_final = pd.concat([df_existente, novos_dados], ignore_index=True)
    df_final.to_excel(caminho_arquivo, index=False)

df = pd.read_excel('dominios.xlsx', sheet_name='Sheet1')
if 'STATUS' in df.columns:
    df['STATUS'] = df['STATUS'].astype(str)
else:
    df['STATUS'] = ''

for i, row in df.iterrows():
    dominio = row['DOMINIO']
    estado = row.get('ESTADO', '')
    municipio = row.get('MUNICIPIO', '')
    status = row.get('STATUS', '')
    data_extracao = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    if status.lower() not in ['sucesso', 'erro']:
        try:
            subpaginas = extrair_subpaginas(dominio)
            if subpaginas:
                salvar_subpaginas_excel(dominio, subpaginas, estado, municipio)
                df.at[i, 'STATUS'] = 'SUCESSO'
            else:
                df.at[i, 'STATUS'] = 'SEM DADOS'
        except Exception as e:
            print(f"Erro ao processar {dominio}: {e}")
            df.at[i, 'STATUS'] = 'ERRO'
        
        df.at[i, 'DATA EXTRACAO'] = data_extracao

print('Salvando resultados no Excel...')
df.to_excel('dominios.xlsx', index=False)
print('Processo concluído.')
driver.quit()
