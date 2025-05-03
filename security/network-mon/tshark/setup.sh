#!/bin/bash

# =============================================
# TShark Installer (Network Monitoring)
# =============================================

# Configuración
LOG_FILE="/var/log/tshark-install.log"
CONTAINER_NAME="tshark-monitor"
INTERFACE="eth0"  # Cambiar según tu interfaz de red
CAPTURE_DIR="/data/captures"

# Función para loggear
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Verificar root
if [ "$(id -u)" -ne 0 ]; then
    echo "Ejecutando con sudo..."
    exec sudo bash "$0" "$@"
    exit $?
fi

# Encabezado
echo "=====================================" | tee -a "$LOG_FILE"
echo "  Instalación TShark (Wireshark CLI)  " | tee -a "$LOG_FILE"
echo "=====================================" | tee -a "$LOG_FILE"
log "Iniciando instalación..."

# 1. Instalar dependencias
log "Instalando dependencias..."
apt-get update >> "$LOG_FILE" 2>&1
apt-get install -y docker.io docker-compose >> "$LOG
