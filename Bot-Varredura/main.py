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
from urllib.parse import urlparse, urljoin
from datetime import datetime

# 🔧 Controle do modo headless
usar_headless = True  
segunda_tentativa = False  

def configurar_driver(headless=True):
    chrome_options = Options()
    
    # Configurações gerais para segurança e compatibilidade
    chrome_options.add_argument('--ignore-certificate-errors')
    chrome_options.add_argument('--ssl-version-min=tls1.2')
    chrome_options.add_argument('--allow-insecure-localhost')
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    
    # Desabilitar aceleração de GPU e renderização por hardware, útil tanto no headless quanto no modo gráfico
    chrome_options.add_argument('--disable-gpu')
    chrome_options.add_argument('--disable-software-rasterizer')
    chrome_options.add_argument('--use-gl=swiftshader')
    chrome_options.add_argument('--disable-features=VizDisplayCompositor')
    chrome_options.add_argument('--disable-accelerated-video-decode')
    chrome_options.add_argument('--disable-accelerated-2d-canvas')
    chrome_options.add_argument('--disable-accelerated-jpeg-decoding')

    # Se o parâmetro 'headless' for True, configura o navegador para rodar sem interface gráfica
    if headless:
        chrome_options.add_argument('--headless=new')  # Para usar o novo headless (disponível a partir do Chrome 112+)

    # Cria e retorna o driver do Chrome com as opções configuradas
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)
    
    return driver

def esperar_carregamento_completo(driver, timeout=50):
    """Aguarda a página carregar completamente verificando document.readyState."""
    try:
        WebDriverWait(driver, timeout).until(lambda d: d.execute_script("return document.readyState") == "complete")
        time.sleep(10)  # 🔄 Tempo extra para carregamento dinâmico
    except TimeoutException:
        print("⚠️ Tempo limite excedido ao carregar a página.")

def normalizar_url(url, dominio):
    """Normaliza URLs para evitar duplicatas e entradas inválidas."""
    try:
        parsed = urlparse(url)
        if not parsed.scheme:
            return urljoin(f"https://{dominio}", parsed.path)
        return f"{parsed.scheme}://{parsed.netloc}{parsed.path}"
    except Exception:
        return None

def extrair_subpaginas(domain, tentativa=1):
    """Extrai subpáginas do site, reprocessando se necessário."""
    global usar_headless, segunda_tentativa  

    domain = domain.strip()
    full_url = f"https://www.{domain}"
    print(f"Tentativa {tentativa} - Acessando: {full_url} (headless={usar_headless})")

    # Caso seja a segunda tentativa, desativa o headless
    if tentativa == 2:
        usar_headless = False  # Segunda tentativa SEM headless
    if tentativa == 1 or (tentativa == 2 and not usar_headless):
        driver = configurar_driver(headless=usar_headless)

    try:
        driver.get(full_url)
        esperar_carregamento_completo(driver)
    except WebDriverException as e:
        print(f"❌ Erro ao acessar {full_url}: {e}")
        driver.quit()
        return set()

    subpaginas = set()
    keywords_to_exclude = ["/#", "mailto:", "@"]

    # 🔴 **EXTENSÕES A SEREM FILTRADAS** 🔴
    extensoes_excluidas = ('.png', '.jpg', '.jpeg', '.gif', '.bmp', '.svg', '.webp', '.pdf', 
                           '.docx', '.pptx', '.zip', '.rar', '.tar', '.gz', '.mp3', '.mp4', 
                           '.avi', '.mov', '.mkv', '.ogg', '.wav', '.exe', '.dmg')

    try:
        links = WebDriverWait(driver, 10).until(EC.presence_of_all_elements_located((By.TAG_NAME, 'a')))
        for link in links:
            try:
                href = link.get_attribute("href")
                if href:
                    href = normalizar_url(href, domain)
                    if (href and domain in href and 
                        not any(keyword in href for keyword in keywords_to_exclude) and 
                        not href.lower().endswith(extensoes_excluidas)):
                        subpaginas.add(href)
            except StaleElementReferenceException:
                continue
    except TimeoutException:
        print("⚠️ Nenhum link encontrado de forma normal. Tentando abordagem JavaScript...")

    # 🧐 **Extração JavaScript**
    try:
        js_links = driver.execute_script("""
            return Array.from(document.querySelectorAll('a'))
                        .map(a => a.href)
                        .filter(href => href);
        """)

        for href in js_links:
            href = normalizar_url(href, domain)
            if (href and domain in href and 
                not any(keyword in href for keyword in keywords_to_exclude) and 
                not href.lower().endswith(extensoes_excluidas)):
                subpaginas.add(href)

    except Exception as e:
        print(f"⚠️ Erro ao capturar links via JS: {e}")

    driver.quit()  # Fecha o navegador após cada execução

    if not subpaginas and tentativa == 1:
        segunda_tentativa = True  # ⚠️ Habilita a segunda tentativa
        return extrair_subpaginas(domain, tentativa=2)

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

    print(f"✅ URLs extraídas de {pagina}: {len(subpaginas)}")
    df_final = pd.concat([df_existente, novos_dados], ignore_index=True)
    df_final.to_excel(caminho_arquivo, index=False)

# Lendo domínios do Excel
df = pd.read_excel('dominios.xlsx', sheet_name='Sheet1')
df = df.drop_duplicates(subset=['DOMINIO'])
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

    usar_headless = True  # 🔄 Sempre começa em headless para o próximo domínio
    segunda_tentativa = False  # Reseta a segunda tentativa

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

print('💾 Salvando resultados no Excel...')
df.to_excel('dominios.xlsx', index=False)
print('✅ Processo concluído.')
