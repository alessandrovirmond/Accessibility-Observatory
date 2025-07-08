#!/bin/bash
clear
echo "🔧 Iniciando execução..."
sleep 1


if [ -f Bot-AxeDevTools/insumo-bot-axe.xlsx ]; then
  echo "🗑️  Removendo arquivo antigo de insumo..."
  rm Bot-AxeDevTools/insumo-bot-axe.xlsx
else
  echo "Arquivo insumo-bot-axe.xlsx não encontrado (tudo certo, será gerado)"
fi


if [ ! -f venv/bin/activate ]; then
  echo "Ambiente virtual 'venv' não encontrado. Criando um novo..."
  python3 -m venv venv
  source venv/bin/activate
  pip install --upgrade pip
  pip install pandas openpyxl
else
  echo "✅ Ativando ambiente virtual"
  source venv/bin/activate
fi

echo "🚀 Executando Bot-Varredura..."
cd Bot-Varredura/
python3 main.py
cd ..

echo "🚀 Executando Bot-AxeDevTools..."
cd Bot-AxeDevTools/
python3 main.py
cd ..

echo "✅ Execução finalizada!"

