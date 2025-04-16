#!/bin/bash

echo "🚀 Inicializando la base de datos si no existe..."

exec odoo -i base

echo "✅ Base de datos lista. Lanzando Odoo..."
