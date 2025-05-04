#!/bin/bash

# Variables
VENV_NAME="prowler-venv"
PROFILE_NAME="default"

echo "[+] Instalando dependencias del sistema..."
sudo apt update && sudo apt install -y python3-venv unzip awscli git

echo "[+] Clonando repositorio oficial de Prowler..."
git clone https://github.com/prowler-cloud/prowler.git
cd prowler

echo "[+] Creando entorno virtual Python..."
python3 -m venv ~/$VENV_NAME
source ~/$VENV_NAME/bin/activate

echo "[+] Instalando Prowler desde PyPI..."
pip install prowler

echo "[+] Configurando credenciales AWS..."
aws configure --profile $PROFILE_NAME

echo "[+] Ejecutando primer escaneo..."
prowler aws --severity critical high --output-formats csv --profile $PROFILE_NAME | tee /var/log/prowler-scan.log

echo "[+] Instalación y escaneo completado."
