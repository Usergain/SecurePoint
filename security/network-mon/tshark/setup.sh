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
apt-get install -y docker.io docker-compose >> "$LOG_FILE" 2>&1

# 2. Configurar directorios
log "Preparando entorno..."
mkdir -p "$CAPTURE_DIR" && chmod -R 777 "$CAPTURE_DIR"

# 3. Verificar Dockerfile y compose
if [ ! -f "Dockerfile" ] || [ ! -f "docker-compose.yml" ]; then
    log "ERROR: Faltan Dockerfile o docker-compose.yml"
    exit 1
fi

# 4. Construir e iniciar contenedor
log "Iniciando TShark..."
docker-compose up -d >> "$LOG_FILE" 2>&1

# 5. Verificar estado
sleep 5  # Esperar inicialización
if docker ps | grep -q "$CONTAINER_NAME"; then
    log "TShark instalado correctamente."
    log "Capturas guardadas en: $CAPTURE_DIR"
    log "Ver logs: docker logs -f $CONTAINER_NAME"
else
    log "ERROR: Contenedor no iniciado. Ver $LOG_FILE"
    exit 1
fi

echo "=====================================" | tee -a "$LOG_FILE"
echo "  Instalación completada             " | tee -a "$LOG_FILE"
echo "=====================================" | tee -a "$LOG_FILE"


