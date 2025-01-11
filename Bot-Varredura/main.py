

import time
import pandas as pd
import os
from selenium.webdriver.chrome.options import Options
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.support.ui import WebDriverWait
import keyboard
from datetime import datetime



chrome_options = Options()
chrome_options.add_argument('--ignore-certificate-errors')
chrome_options.add_argument('--ssl-version-min=tls1.2')
chrome_options.add_argument('--allow-insecure-localhost')
chrome_options.add_argument('--headless=new')


driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)

def esperar_carregamento_completo(driver, timeout=10):
    WebDriverWait(driver, timeout).until(
        lambda d: d.execute_script("return document.readyState") == "complete"
    )
    time.sleep(3)

def extrair_subpaginas(domain):
    #
    full_url = "https://www." + domain
    driver.get(full_url)

    esperar_carregamento_completo(driver)


    links = driver.find_elements('tag name', 'a')

    subpaginas = set()

    keywords_to_exclude = ["/#", "mailto:", "@"]
    for link in links:
        href = link.get_attribute("href")



        if href and domain in href:
            if href.endswith(('.png', '.jpg', '.jpeg', '.gif', '.bmp', '.svg', '.webp', '.pdf', '.docx', 'pptx')) or any(keyword in href for keyword in keywords_to_exclude):
                continue

            subpaginas.add(href)



    return subpaginas



def salvar_subpaginas_excel(pagina, subpaginas):
    caminho_arquivo = '../Bot-AxeDevTools/insumo-bot-axe.xlsx'

    data_extracao = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    if os.path.exists(caminho_arquivo):
        df_existente = pd.read_excel(caminho_arquivo)
    else:
        df_existente = pd.DataFrame(columns=['DOMINIO', 'URLS', 'DATA EXTRACAO', 'STATUS AXE', 'DATA TESTE AXE'])



    df_existente = df_existente[df_existente['DOMINIO'] != pagina]

    novos_dados = pd.DataFrame({
        'DOMINIO': [pagina] * len(subpaginas),
        'URLS': list(subpaginas),
        'DATA EXTRACAO': data_extracao,

    })


    df_final = pd.concat([df_existente, novos_dados], ignore_index=True)


    df_final.to_excel(caminho_arquivo, index=False)



pausar = False

def verificar_pausa():
    global pausar
    if pausar:
        input("Execução pausada. Pressione Enter para continuar...")
        pausar = False


def acessar_subpaginas(subpaginas):
    global pausar
    for subpagina in subpaginas:

        print(f"Acessando: {subpagina}")


        tempo_total_espera = 1.0
        intervalos = 0.1
        total_passos = int(tempo_total_espera / intervalos)

        for _ in range(total_passos):
            if keyboard.is_pressed('p'):
                pausar = True
            verificar_pausa()

            time.sleep(intervalos)


        driver.get(subpagina)

df = pd.read_excel('dominios.xlsx', sheet_name='Sheet1')


if 'STATUS' in df.columns:
    df['STATUS'] = df['STATUS'].astype(str)
else:
    df['STATUS'] = ''







for i, row in df.iterrows():
    dominio = row['DOMINIO']
    full_url = "https://www." + dominio
    status = row.get('STATUS', '')


    data_extracao = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    if status == 'nan':
        df['DATA EXTRACAO'] = df['DATA EXTRACAO'].astype(str)
        try:
            print(f"Extraindo subpáginas para o domínio: {dominio}")
            subpaginas = extrair_subpaginas(dominio)


            salvar_subpaginas_excel(full_url, subpaginas)


            df.at[i, 'STATUS'] = 'SUCESSO'

        except Exception as e:
            print(f"Erro ao processar o domínio {dominio}: {str(e)}")
            df.at[i, 'STATUS'] = 'ERRO'

        df.at[i, 'DATA EXTRACAO'] = data_extracao





print('salvando URLS no excel')
df.to_excel('dominios.xlsx', index=False)

print('fim da execucao')

driver.quit()

