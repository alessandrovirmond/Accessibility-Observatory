#!/bin/bash

set -e  

clear
echo "🔧 Iniciando setup do ambiente..."


if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 não está instalado. Instale com: sudo apt install python3"
    exit 1
fi


if ! python3 -m venv --help &> /dev/null; then
    echo "⏳ Instalando python3-venv..."
    sudo apt update
    sudo apt install -y python3-venv
fi


if [ ! -d "venv" ]; then
    echo "📦 Criando ambiente virtual 'venv'..."
    python3 -m venv venv
else
    echo "✅ Ambiente virtual 'venv' já existe."
fi


echo "⚙️  Ativando ambiente virtual..."
source venv/bin/activate


if [ -f requirements.txt ]; then
    echo "📥 Instalando dependências Python do requirements.txt..."
    pip install --upgrade pip
    pip install -r requirements.txt
else
    echo "❌ Arquivo requirements.txt não encontrado!"
    exit 1
fi


if ! command -v google-chrome &> /dev/null; then
    echo "🌐 Google Chrome não encontrado. Instalando..."
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y ./google-chrome-stable_current_amd64.deb
    rm google-chrome-stable_current_amd64.deb
else
    echo "✅ Google Chrome já instalado: $(google-chrome --version)"
fi

if ! command -v npm &> /dev/null; then
    echo "📦 Instalando npm..."
    sudo apt install -y npm
else
    echo "✅ npm já instalado: $(npm -v)"
fi


if [ -d "API" ]; then
    echo "📂 Instalando dependências Node.js em ./api..."
    cd ./API
    npm install
    cd ..
else
    echo "⚠️ Pasta 'api' não encontrada. Pulei o npm install."
fi

echo "✅ Setup concluído!"
echo "👉 Ative o ambiente com: source venv/bin/activate"
echo "👉 Depois rode: ./run.sh"
