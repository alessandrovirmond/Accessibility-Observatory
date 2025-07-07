#!/bin/bash

echo "🚀 Iniciando build Flutter Web..."

FLUTTER=~/flutter/bin/flutter
FRONT_DIR="Front"
BUILD_DIR="$FRONT_DIR/build/web"

# Verifica se Flutter existe
if [ ! -f "$FLUTTER" ]; then
    echo "❌ Flutter não encontrado em $FLUTTER"
    exit 1
fi

# Verifica se o projeto existe
if [ ! -d "$FRONT_DIR" ]; then
    echo "❌ Diretório $FRONT_DIR não encontrado!"
    exit 1
fi

cd "$FRONT_DIR"

# Build do Flutter Web
$FLUTTER build web || { echo "❌ Erro ao buildar Flutter Web."; exit 1; }

cd build/web

# Verifica Python 3
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 não encontrado. Instale com: sudo apt install python3"
    exit 1
fi

# Sobe o servidor em background
echo "📡 Iniciando servidor local em http://localhost:8080 ..."
python3 -m http.server 8080 > /dev/null 2>&1 &

SERVER_PID=$!

# Espera alguns segundos para garantir que o servidor subiu
sleep 2

# Abre o navegador
if command -v xdg-open &> /dev/null; then
    echo "🌐 Abrindo navegador..."
    xdg-open http://localhost:8080
else
    echo "ℹ️ Acesse manualmente: http://localhost:8080"
fi

# Mantém o terminal aberto com o servidor rodando
echo "✅ Servidor rodando com PID $SERVER_PID. Pressione Ctrl+C para parar."
wait $SERVER_PID
