#!/bin/bash

echo "🚀 Iniciando setup Flutter..."

FRONT_DIR="./Front"

if [ ! -d "$FRONT_DIR" ]; then
  echo "❌ Diretório do projeto Flutter não encontrado: $FRONT_DIR"
  exit 1
fi

cd "$FRONT_DIR"

# Verifica se o Flutter está instalado
if ! command -v flutter &> /dev/null
then
    echo "❌ Flutter não encontrado. Instale com:"
    echo "   git clone https://github.com/flutter/flutter.git -b stable"
    echo "   export PATH=\"\$PATH:\$PWD/flutter/bin\""
    exit 1
else
    echo "✅ Flutter encontrado: $(flutter --version)"
fi

# Instala as dependências do projeto
echo "📦 Rodando flutter pub get..."
flutter pub get

echo "✅ Setup Flutter finalizado!"
