#!/bin/bash

echo "🛠️ Iniciando setup do banco de dados..."

DB_NAME="observatorio"
DB_USER="observatorio"
DB_PASS="observatorio"
DB_HOST="127.0.0.1"
SQL_FILE="./API/observatorio.sql"

# Verifica se o mysql está instalado (cliente)
if ! command -v mysql &> /dev/null; then
  echo "🔍 Cliente MySQL não encontrado. Instalando..."
  sudo apt update
  sudo apt install -y mysql-client
fi

# Verifica se o servidor MySQL está instalado
if ! dpkg -l | grep -q mysql-server; then
  echo "🧩 Servidor MySQL não encontrado. Instalando..."
  sudo apt install -y mysql-server
fi

# Verifica se o serviço do MySQL está ativo
if ! systemctl is-active --quiet mysql; then
  echo "🚀 Iniciando serviço MySQL..."
  sudo systemctl start mysql
fi

# Cria o usuário e o banco (caso não existam)
echo "🔐 Verificando usuário e banco de dados..."
sudo mysql <<EOF
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

# Verifica se o arquivo SQL existe
if [ ! -f "$SQL_FILE" ]; then
  echo "❌ Arquivo SQL não encontrado: $SQL_FILE"
  exit 1
fi

# Executa o script SQL
echo "📥 Importando dados para o banco..."
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$SQL_FILE"

echo "✅ Banco de dados configurado com sucesso!"