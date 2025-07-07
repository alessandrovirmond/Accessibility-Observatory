#!/bin/bash

echo "🚀 Iniciando setup Flutter..."

FRONT_DIR="./Front"

if [ ! -d "$FRONT_DIR" ]; then
  echo "❌ Diretório do projeto Flutter não encontrado: $FRONT_DIR"
  exit 1
fi

# Verifica se o Flutter está no PATH
if ! command -v flutter &> /dev/null; then
    echo "⚠️ Flutter não encontrado. Verificando se pasta flutter já existe em ~/flutter..."

    if [ ! -d "$HOME/flutter" ]; then
        echo "📥 Clonando Flutter em ~/flutter..."
        git clone https://github.com/flutter/flutter.git -b stable ~/flutter
    else
        echo "⚠️ Diretório ~/flutter já existe. Pulei a clonagem."
    fi

    export PATH="$HOME/flutter/bin:$PATH"
    echo "✅ Flutter instalado com sucesso."
else
    echo "✅ Flutter encontrado: $(flutter --version)"
fi

# Verifica se o curl está instalado
if ! command -v curl &> /dev/null; then
    echo "❌ curl não encontrado. Instalando com apt-get..."
    sudo apt-get update
    sudo apt-get install curl -y
else
    echo "✅ curl já instalado."
fi

# Entra no diretório do front-end e instala dependências
cd "$FRONT_DIR"
echo "📦 Rodando flutter pub get..."
flutter pub get

echo "✅ Setup Flutter finalizado!"
