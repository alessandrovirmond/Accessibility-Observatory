#!/bin/bash

echo "🚀 Iniciando setup Flutter..."

FRONT_DIR="./Front"
FLUTTER_DIR="$HOME/flutter"  # ou use "./flutter" se preferir local ao projeto

# Verifica se o diretório do projeto Flutter existe
if [ ! -d "$FRONT_DIR" ]; then
  echo "❌ Diretório do projeto Flutter não encontrado: $FRONT_DIR"
  exit 1
fi

# Verifica se o Flutter está instalado
if ! command -v flutter &> /dev/null; then
  echo "🔧 Flutter não encontrado. Instalando em $FLUTTER_DIR..."
  
  # Clona o Flutter SDK
  git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR"
  
  # Atualiza o PATH na sessão atual
  export PATH="$PATH:$FLUTTER_DIR/bin"
  
  echo "✅ Flutter instalado com sucesso."
else
  echo "✅ Flutter encontrado: $(flutter --version)"
fi

# Entra no diretório do projeto
cd "$FRONT_DIR"

# Atualiza o PATH novamente aqui, para garantir que funcione mesmo após o cd
if [ -d "$FLUTTER_DIR/bin" ]; then
  export PATH="$PATH:$FLUTTER_DIR/bin"
fi

# Instala as dependências
echo "📦 Rodando flutter pub get..."
flutter pub get

echo "✅ Setup Flutter finalizado!"
