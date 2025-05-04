#!/bin/bash
# setup_prowler.sh - Instalación modular de Prowler con configuración para Promtail
# Requiere: Ubuntu 22.04 o 24.04, acceso root

set -e

## [1/5] Config global
LOG_DIR="/var/log"
PROWLER_LOG="$LOG_DIR/prowler-scan.log"
PROMTAIL_CONFIG="/etc/promtail-config.yaml"

## [2/5] Dependencias base
install_dependencies() {
  echo "[1/5] Instalando dependencias base..."
  sudo apt update
  sudo apt install -y git unzip curl

  if ! command -v aws &>/dev/null; then
    echo "[2/5] Instalando AWS CLI..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    sudo ./aws/install --update
    rm -rf aws awscliv2.zip
  fi
}

## [3/5] Clonar y preparar Prowler
setup_prowler() {
  echo "[3/5] Clonando Prowler..."
  git clone https://github.com/prowler-cloud/prowler.git ~/prowler || true
  cd ~/prowler
  chmod +x prowler
}

## [4/5] Ejecutar escaneo manual
run_scan() {
  echo "[4/5] Ejecutando escaneo inicial..."
  sudo mkdir -p "$LOG_DIR"
  sudo touch "$PROWLER_LOG"
  sudo chown $USER:$USER "$PROWLER_LOG"
  ./prowler -M csv -S HIGH,CRITICAL | tee "$PROWLER_LOG" > /dev/null
}

## [5/5] Configurar Promtail
setup_promtail_config() {
  echo "[5/5] Añadiendo Prowler a promtail-config.yaml..."
  if ! grep -q "prowler-scan.log" "$PROMTAIL_CONFIG"; then
    sudo tee -a "$PROMTAIL_CONFIG" > /dev/null <<EOF

  - job_name: prowler
    static_configs:
      - targets: ['localhost']
        labels:
          job: prowler
          host: odoo-node
          __path__: $PROWLER_LOG
EOF
    sudo systemctl restart promtail
  else
    echo "  [!] Entrada ya existe en promtail-config.yaml, omitiendo..."
  fi
}

# Ejecutar todo
install_dependencies
setup_prowler
run_scan
setup_promtail_config

echo -e "\n✅ Instalación completada. Los resultados de Prowler se están enviando a Grafana.\n"
