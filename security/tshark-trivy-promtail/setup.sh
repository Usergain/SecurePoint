#!/bin/bash

set -e

echo "[*] Instalando dependencias..."
sudo apt update && sudo apt install -y unzip curl wget gnupg lsb-release tshark

echo "[*] Descargando Promtail..."
cd /tmp
wget -q https://github.com/grafana/loki/releases/latest/download/promtail-linux-amd64.zip
unzip -o promtail-linux-amd64.zip
chmod +x promtail-linux-amd64
sudo mv promtail-linux-amd64 /usr/local/bin/promtail

echo "[*] Descargando Trivy..."
wget -q https://github.com/aquasecurity/trivy/releases/latest/download/trivy_0.51.1_Linux-64bit.deb
sudo apt install -y ./trivy_0.51.1_Linux-64bit.deb

echo "[*] Copiando archivos de configuración..."
sudo cp config/promtail-config.yaml /etc/promtail-config.yaml
sudo touch /var/log/tshark.log /var/log/trivy.log
sudo chown root:root /var/log/tshark.log /var/log/trivy.log
sudo chmod 644 /var/log/tshark.log /var/log/trivy.log

echo "[*] Instalando servicios systemd..."
sudo cp systemd/*.service /etc/systemd/system/
sudo cp systemd/*.timer /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now tshark-loop.service
sudo systemctl enable --now promtail.service
sudo systemctl enable --now trivy-scan.timer

echo "[+] Instalación completada. Puedes consultar los logs desde Grafana con los filtros job=tshark y job=trivy"
