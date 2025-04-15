#!/bin/bash

echo "🚀 Inicializando la base de datos si no existe..."

exec odoo \
  --db_host="$DB_HOST" \
  --db_port="${DB_PORT:-5432}" \
  --db_user="$DB_USER" \
  --db_password="$DB_PASSWORD" \
  -d "$DB_NAME"
  -i base

  echo "✅ Base de datos lista. Lanzando Odoo..."
