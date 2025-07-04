#!/bin/bash

echo "🛠️ Iniciando setup do banco de dados..."

DB_NAME="observatorio"
DB_USER="observatorio"
DB_PASS="observatorio"
DB_HOST="127.0.0.1"
SQL_FILE="./API/observatorio.sql"

# Verifica se o mysql está instalado
if ! command -v mysql &> /dev/null; then
  echo "🔍 Cliente MySQL não encontrado. Instalando..."
  sudo apt update
  sudo apt install -y mysql-client

  if ! command -v mysql &> /dev/null; then
    echo "❌ Falha ao instalar o cliente MySQL. Verifique se você tem permissões suficientes."
    exit 1
  fi
fi

# Verifica se o arquivo SQL existe
if [ ! -f "$SQL_FILE" ]; then
  echo "❌ Arquivo SQL não encontrado: $SQL_FILE"
  exit 1
fi

# Cria o banco (caso não exista)
echo "📦 Criando banco de dados (se necessário)..."
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"

# Executa o script SQL
echo "📥 Importando dados para o banco..."
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$SQL_FILE"

echo "✅ Banco de dados configurado com sucesso!"
