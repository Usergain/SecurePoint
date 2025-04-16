#!/bin/sh

set -e

echo "⏳ Esperando a que la base de datos esté disponible..."

# Esperar a que la base de datos acepte conexiones
while ! nc -z "${DB_HOST}" "${DB_PORT}" 2>/dev/null; do
    sleep 1
done

echo "✅ Base de datos disponible."

# Ejecutar Odoo
exec odoo \
    --http-port="${PORT:-8069}" \
    --init=all \
    --without-demo=True \
    --proxy-mode \
    --db_host="${DB_HOST}" \
    --db_port="${DB_PORT}" \
    --db_user="${DB_USER}" \
    --db_password="${DB_PASSWORD}" \
    --database="panaderia_estrella" \
    --log-level=info
