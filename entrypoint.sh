#!/bin/bash

# Asignar valores por defecto si alguna variable no está definida
DB_PORT="${DB_PORT:-5432}"

# Ejecutar Odoo con parámetros explícitos
exec odoo \
  --db_host="$DB_HOST" \
  --db_port="$DB_PORT" \
  --db_user="$DB_USER" \
  --db_password="$DB_PASSWORD" \
  --db_name="$DB_NAME"
