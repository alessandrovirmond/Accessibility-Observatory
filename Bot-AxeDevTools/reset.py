import pandas as pd
import json
import os

row = 5


def reset_excel_status():
    # Carrega o arquivo Excel
    file_path = './insumo-bot-2.xlsx'
    
    if os.path.exists(file_path):
        df = pd.read_excel(file_path)
        

        if 'STATUS' in df.columns:
            df.at[row, 'STATUS'] = 'nan'
            

            df.to_excel(file_path, index=False)
            print(f"Status da linha {row} resetado no arquivo {file_path}.")
        else:
            print("Coluna 'STATUS' não encontrada no arquivo Excel.")
    else:
        print(f"Arquivo Excel {file_path} não encontrado.")



def reset_json_file():
    json_file_path = 'relatorio_acessibilidade.json'
    

    with open(json_file_path, 'w', encoding='utf-8') as f:
        json.dump({}, f, ensure_ascii=False, indent=4)
        print(f"Arquivo JSON {json_file_path} resetado.")


reset_excel_status()
reset_json_file()
