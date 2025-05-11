#!/bin/bash

LOKI_URL="$1"

set -e

echo ">> Instalando Promtail"
wget https://github.com/grafana/loki/releases/download/v2.9.4/promtail-linux-amd64.zip
unzip promtail-linux-amd64.zip
chmod +x promtail-linux-amd64
sudo mv promtail-linux-amd64 /usr/local/bin/promtail

echo ">> Configurando promtail-config.yaml"
sudo tee /etc/promtail-config.yaml > /dev/null <<EOF
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: ${LOKI_URL}/loki/api/v1/push

scrape_configs:
  - job_name: prowler
    static_configs:
      - targets: ['localhost']
        labels:
          job: prowler
          host: security-node
          __path__: /var/log/prowler.log
EOF

echo ">> Configurando servicio Promtail"
sudo tee /etc/systemd/system/promtail.service > /dev/null <<EOF
[Unit]
Description=Promtail service
After=network.target

[Service]
ExecStart=/usr/local/bin/promtail -config.file=/etc/promtail-config.yaml
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now promtail

echo "✅ Promtail configurado y enviando logs a Loki"
