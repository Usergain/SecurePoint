#!/bin/bash

# === CARGA DE CONFIGURACIÓN ===
CONFIG_FILE="./setup.conf"
if [[ -f "$CONFIG_FILE" ]]; then
  source "$CONFIG_FILE"
else
  echo "Fichero de configuración $CONFIG_FILE no encontrado. Abortando."
  exit 1
fi

# === PREPARACIÓN DEL SISTEMA ===
echo "[+] Instalando dependencias"
sudo apt update && sudo apt install -y unzip tshark curl

# === DIRECTORIOS ===
echo "[+] Creando estructura de directorios"
mkdir -p "$SECURITY_DIR" && cd "$SECURITY_DIR"

# === DESCARGA DE PROMTAIL ===
echo "[+] Descargando Promtail"
curl -LO "$PROMTAIL_URL"
unzip promtail-linux-amd64.zip
chmod +x promtail-linux-amd64
sudo mv promtail-linux-amd64 "$PROMTAIL_BIN"

# === CONFIGURACIÓN DE PROMTAIL ===
echo "[+] Configurando promtail"
cat <<EOF | sudo tee /etc/promtail-config.yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: $LOKI_SERVER_URL

scrape_configs:
  - job_name: tshark
    static_configs:
      - targets:
          - localhost
        labels:
          job: tshark
          host: tshark-node
          __path__: /var/log/tshark.log
EOF

# === SERVICIO SYSTEMD PARA PROMTAIL + TSHARK ===
echo "[+] Creando servicio systemd"
cat <<EOF | sudo tee /etc/systemd/system/promtail.service
[Unit]
Description=Looped TShark Logger with Cleanup
After=network.target

[Service]
ExecStart=/bin/bash -c '\
  while true; do \
    if [ -f /var/log/tshark.log ] && [ \\\n         \$(du -m /var/log/tshark.log | cut -f1) -ge 50 ]; then \
      echo "" > /var/log/tshark.log; \
    fi; \
    tshark -i any -c 1000 >> /var/log/tshark.log 2>&1; \
    sleep 5; \
  done'
Restart=always
RestartSec=10
User=root

[Install]
WantedBy=multi-user.target
EOF

# === INICIAR SERVICIO ===
echo "[+] Habilitando e iniciando servicio"
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable promtail
sudo systemctl start promtail

# === CONFIRMACIÓN ===
echo "✅ Promtail + TShark en ejecución. Logs siendo enviados a Loki."
echo "🔍 Verifica en Grafana (Explore) con: {job=\"tshark\"}"
