#!/bin/bash

set -e  

clear
echo "🔧 Iniciando setup do ambiente..."


if [ "$(id -u)" -eq 0 ]; then
    echo "⚠️ Este script não deve ser executado com sudo. Execute como usuário regular."
    exit 1
fi


if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 não está instalado. Instalando..."
    sudo apt update
    sudo apt install -y python3
else
    echo "✅ Python 3 já instalado: $(python3 --version)"
fi


if ! python3 -m venv --help &> /dev/null; then
    echo "⏳ Instalando python3-venv..."
    sudo apt update
    sudo apt install -y python3-venv
else
    echo "✅ python3-venv já instalado."
fi


if ! command -v pip3 &> /dev/null; then
    echo "⏳ Instalando python3-pip..."
    sudo apt update
    sudo apt install -y python3-pip
else
    echo "✅ pip já instalado: $(pip3 --version)"
fi


ARCH=$(dpkg --print-architecture)
if ! command -v google-chrome &> /dev/null; then
    echo "🌐 Google Chrome não encontrado. Instalando para arquitetura $ARCH..."
    if [ "$ARCH" = "amd64" ]; then
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        sudo dpkg -i google-chrome-stable_current_amd64.deb || sudo apt install -f -y
        rm google-chrome-stable_current_amd64.deb
    else
        echo "⚠️ Arquitetura $ARCH não suportada para Chrome. Pulando instalação."
    fi
else
    echo "✅ Google Chrome já instalado: $(google-chrome --version)"
fi


if ! command -v npm &> /dev/null; then
    echo "📦 Instalando npm..."
    sudo apt update
    sudo apt install -y npm
else
    echo "✅ npm já instalado: $(npm -v)"
fi




if [ ! -d "venv" ]; then
    echo "📦 Criando ambiente virtual 'venv'..."
    python3 -m venv venv
else
    echo "✅ Ambiente virtual 'venv' já existe."
fi


echo "🔐 Ajustando permissões do ambiente virtual..."
sudo chown -R $USER:$USER venv


if [ ! -x "venv/bin/python3" ]; then
    echo "❌ Erro: venv/bin/python3 não encontrado ou não é executável!"
    exit 1
fi


echo "⚙️ Ativando ambiente virtual para Python..."
source venv/bin/activate



if [ -f requirements.txt ]; then
    echo "📥 Instalando dependências Python do requirements.txt..."
    ./venv/bin/pip install --upgrade pip
    ./venv/bin/pip install -r requirements.txt
else
    echo "❌ Arquivo requirements.txt não encontrado!"
    exit 1
fi


echo "⚙️ Desativando ambiente virtual..."
deactivate




if [ -d "API" ]; then
    echo "📂 Instalando dependências Node.js em ./API..."
    cd ./API
    npm install
    cd ..
else
    echo "⚠️ Pasta 'api' não encontrada. Pulei o npm install."
fi



echo "✅ Setup concluído!"
echo "ℹ️ Para usar o ambiente virtual Python depois, ative-o com: source venv/bin/activate"
echo "👉 Preencha o arquivo Excel do bot de varredura"
echo "👉 Entre na pasta ./API e rode o comando: npm run dev"
echo "👉 Depois rode: ./run.sh na pasta principal"
