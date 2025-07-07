#!/bin/bash

echo "🚀 Iniciando setup Flutter..."

FRONT_DIR="./Front"
FLUTTER_DIR="$HOME/flutter"

# Verifica se Flutter já foi clonado
if [ ! -d "$FLUTTER_DIR" ]; then
    echo "📥 Clonando Flutter em $FLUTTER_DIR..."
    git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR"
else
    echo "✅ Flutter já clonado em $FLUTTER_DIR"
fi

# Adiciona Flutter ao PATH temporariamente
export PATH="$FLUTTER_DIR/bin:$PATH"

# Verifica se já está no bashrc para tornar permanente
if ! grep -q 'flutter/bin' ~/.bashrc; then
    echo "🔧 Adicionando Flutter ao PATH permanentemente (~/.bashrc)..."
    echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
    echo "✅ PATH atualizado. Reinicie o terminal ou rode: source ~/.bashrc"
else
    echo "✅ Flutter já está no PATH do ~/.bashrc"
fi

# Verifica se curl está instalado
if ! command -v curl &> /dev/null; then
    echo "❌ curl não encontrado. Instalando..."
    sudo apt-get update
    sudo apt-get install curl -y
fi

# Verifica se Flutter está funcionando
flutter --version || { echo "❌ Erro ao executar Flutter"; exit 1; }

# Instala dependências do projeto Flutter
if [ -d "$FRONT_DIR" ]; then
    cd "$FRONT_DIR"
    echo "📦 Instalando dependências com flutter pub get..."
    flutter pub get
    echo "✅ Setup Flutter concluído com sucesso!"
else
    echo "❌ Diretório Flutter ($FRONT_DIR) não encontrado!"
    exit 1
fi