#!/bin/sh

set -e

echo "⏳ Esperando a la base de datos..."

# Esperar a que la base de datos esté disponible
while ! nc -z ${DB_HOST} ${DB_PORT} 2>&1; do sleep 1; done; 

echo "✅ Base de datos disponible. Iniciando Odoo..."

exec odoo \
    --http-port="${PORT}" \
    --init=base \
    --without-demo=True \
    --proxy-mode \
    --db_host="${DB_HOST}" \
    --db_port="${DB_PORT}" \
    --db_user="${DB_USER}" \
    --db_password="${DB_PASSWORD}" \
    --database="${DB_NAME}" 2>&1
