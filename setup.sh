#!/bin/bash

set -e

echo "✅ Verificando Docker..."
docker --version
docker-compose --version

echo "✅ Creando carpetas de despliegue..."
mkdir -p ~/securepoint-deployment/odoo
mkdir -p ~/securepoint-deployment/openvas
mkdir -p ~/securepoint-deployment/wireshark

echo "✅ Copiando archivos de Odoo..."
cp -r ./odoo/* ~/securepoint-deployment/odoo/

echo "✅ Copiando archivos de OpenVAS..."
cp -r ./openvas/* ~/securepoint-deployment/openvas/

echo "✅ Copiando archivos de Wireshark..."
cp -r ./wireshark/* ~/securepoint-deployment/wireshark/

echo "✅ Desplegando Odoo..."
cd ~/securepoint-deployment/odoo
sudo docker-compose up -d

echo "✅ Desplegando OpenVAS..."
cd ~/securepoint-deployment/openvas
sudo docker-compose up -d

echo "✅ Desplegando Wireshark..."
cd ~/securepoint-deployment/wireshark
sudo docker-compose up -d

echo "🎯 Todo desplegado correctamente en AWS Ubuntu 🚀"


