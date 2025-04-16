#!/bin/sh

set -e

echo "⏳ Esperando a que la base de datos esté disponible..."

# Esperar a que la base de datos acepte conexiones
while ! nc -z "${ODOO_DATABASE_HOST}" "${ODOO_DATABASE_PORT}" 2>/dev/null; do
    sleep 1
done

echo "✅ Base de datos disponible."

# Ejecutar Odoo
exec odoo \
    --http-port="${PORT:-8069}" \
    --init=all \
    --without-demo=True \
    --proxy-mode \
    --db_host="${ODOO_DATABASE_HOST}" \
    --db_port="${ODOO_DATABASE_PORT}" \
    --db_user="${ODOO_DATABASE_USER}" \
    --db_password="${ODOO_DATABASE_PASSWORD}" \
    --database="panaderia_estrella" \
    --log-level=info
