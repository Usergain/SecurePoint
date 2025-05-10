#!/bin/bash

# Variables
PROFILE_NAME="default"
REGION="eu-north-1"

# Crear entorno virtual
python3 -m venv prowler-venv
source prowler-venv/bin/activate

# Actualizar pip y setuptools
pip install --upgrade pip setuptools

# Instalar prowler
pip install prowler

# Configurar AWS CLI (requiere que el usuario tenga las credenciales ya configuradas)
aws configure --profile $PROFILE_NAME

# Ejecutar auditoría
mkdir -p /var/log
prowler aws --profile $PROFILE_NAME \
    --region $REGION \
    --severity critical high \
    --output-formats csv \
    | tee /var/log/prowler-scan.log

echo "✅ Auditoría completa. CSV generado en /home/$(whoami)/output/"
