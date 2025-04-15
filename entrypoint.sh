#!/bin/bash

# Parsear DATABASE_URL si existe
if [[ -n "$DATABASE_URL" ]]; then
  export DB_HOST=$(echo $DATABASE_URL | sed -E 's|.*@([^:/]+).*|\1|')
  export DB_PORT=$(echo $DATABASE_URL | sed -E 's|.*:([0-9]+)/.*|\1|')
  export DB_USER=$(echo $DATABASE_URL | sed -E 's|postgresql://([^:]+):.*|\1|')
  export DB_PASSWORD=$(echo $DATABASE_URL | sed -E 's|postgresql://[^:]+:([^@]+)@.*|\1|')
  export DB_NAME=$(echo $DATABASE_URL | sed -E 's|.*/([^/?]+).*|\1|')
fi

# Ejecutar Odoo con los valores extraídos
exec odoo \
  --db_host="$DB_HOST" \
  --db_port="${DB_PORT:-5432}" \
  --db_user="$DB_USER" \
  --db_password="$DB_PASSWORD" \
  --db_name="$DB_NAME"

