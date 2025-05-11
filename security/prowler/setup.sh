#!/bin/bash

set -e

PROFILE_NAME="default"
REGION="eu-north-1"
LOKI_URL="http://16.171.5.50:3100"

echo ">> Instalando dependencias base"
sudo apt update && sudo apt install -y python3-venv curl rsyslog

echo ">> Creando entorno virtual"
python3 -m venv prowler-venv
source prowler-venv/bin/activate
pip install --upgrade pip setuptools
pip install prowler

echo ">> Configurando entorno de logs"
sudo mkdir -p /var/log
sudo touch /var/log/prowler.log
sudo chmod 666 /var/log/prowler.log

echo 'if $programname == "prowler" then /var/log/prowler.log' | sudo tee /etc/rsyslog.d/30-prowler.conf
echo '& stop' | sudo tee -a /etc/rsyslog.d/30-prowler.conf
sudo systemctl restart rsyslog

echo ">> Creando servicio systemd"
sudo tee /etc/systemd/system/prowler-scan.service > /dev/null <<EOF
[Unit]
Description=Ejecuta Prowler y envía resultados a syslog cada hora

[Service]
Type=oneshot
WorkingDirectory=/home/admin
ExecStart=/home/admin/prowler-venv/bin/prowler aws --region ${REGION} --severity critical high --output-formats csv | logger -t prowler
EOF

sudo tee /etc/systemd/system/prowler-scan.timer > /dev/null <<EOF
[Unit]
Description=Temporizador para escaneos Prowler

[Timer]
OnCalendar=hourly
Persistent=true

[Install]
WantedBy=timers.target
EOF

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable --now prowler-scan.timer

echo ">> Instalando Promtail"
bash promtail-install.sh "$LOKI_URL"

echo "✅ Instalación completada."
