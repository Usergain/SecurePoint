#!/bin/bash

# =============================================
# Suricata IDS Installer (Optimized for 1GB RAM)
# =============================================

# Configuración
LOG_FILE="/var/log/suricata-install.log"
RULES_URL="https://rules.emergingthreats.net/open/suricata-6.0.3/emerging.rules.tar.gz"

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
echo "  Instalación Suricata IDS            " | tee -a "$LOG_FILE"
echo "=====================================" | tee -a "$LOG_FILE"
log "Iniciando instalación..."

# 1. Instalar dependencias
log "Instalando dependencias..."
apt-get update >> "$LOG_FILE" 2>&1
apt-get install -y docker.io docker-compose curl >> "$LOG_FILE" 2>&1

# 2. Configurar directorios
log "Preparando entorno..."
mkdir -p {logs,rules} && chmod -R 777 logs rules

# 3. Descargar reglas
log "Descargando reglas ET Pro..."
curl -sL "$RULES_URL" -o emerging.rules.tar.gz >> "$LOG_FILE" 2>&1
tar -xzf emerging.rules.tar.gz -C rules/ --strip-components=1 >> "$LOG_FILE" 2>&1
rm emerging.rules.tar.gz

# 4. Configuración Suricata
log "Generando configuración..."
cat > suricata.yaml << 'EOL'
%YAML 1.1
---
default-rule-path: /var/lib/suricata/rules
rule-files:
  - emerging*.rules

outputs:
  - fast:
      enabled: yes
      file: /var/log/suricata/fast.log

  - eve-log:
      enabled: yes
      filetype: regular
      filename: eve.json
      types: [alert]
EOL

# 5. Construir e iniciar
log "Iniciando Suricata..."
docker-compose up -d >> "$LOG_FILE" 2>&1

# 6. Verificar
sleep 5
if docker ps | grep -q "suricata-ids"; then
    log "Suricata instalado correctamente."
    log "Logs: $(pwd)/logs"
else
    log "ERROR: Fallo al iniciar. Ver $LOG_FILE"
    exit 1
fi
