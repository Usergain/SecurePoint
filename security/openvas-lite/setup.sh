#!/bin/bash

# =============================================
# OpenVAS Lite Installer (Optimized for 1GB RAM)
# =============================================

# Configuración inicial
LOG_FILE="/var/log/openvas-install.log"
COMPOSE_DIR="/home/admin/SecurePoint/security/openvas-lite"
TIMEOUT_INSTALL=$((SECONDS + 7200)) # 2 horas máximo

# Función para loggear
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Verificar root
if [ "$(id -u)" -ne 0 ]; then
    exec sudo bash "$0" "$@"
    exit $?
fi

# Encabezado de instalación
echo "=====================================" | tee -a "$LOG_FILE"
echo "  Instalación OpenVAS Lite (1GB RAM)  " | tee -a "$LOG_FILE"
echo "=====================================" | tee -a "$LOG_FILE"
log "Iniciando proceso de instalación..."

# 1. Instalar dependencias
log "Instalando dependencias..."
apt-get update >> "$LOG_FILE" 2>&1
apt-get install -y docker.io docker-compose curl jq >> "$LOG_FILE" 2>&1

# Configurar Docker sin sudo
usermod -aG docker admin >> "$LOG_FILE" 2>&1

# 2. Crear estructura de directorios
log "Configurando directorios..."
mkdir -p "$COMPOSE_DIR"/{config,data} || { log "Error creando directorios"; exit 1; }
cd "$COMPOSE_DIR" || exit

# 3. Verificar docker-compose.yml existe
if [ ! -f "docker-compose.yml" ]; then
    log "ERROR: docker-compose.yml no encontrado en $COMPOSE_DIR"
    log "Por favor coloca el archivo docker-compose.yml en el directorio antes de ejecutar"
    exit 1
else
    log "Usando docker-compose.yml existente"
fi

# 4. Asegurar permisos correctos en los directorios
log "Configurando permisos..."
mkdir -p "$COMPOSE_DIR"/data
chown -R 1000:1000 "$COMPOSE_DIR"/data
chmod -R 775 "$COMPOSE_DIR"/data
find "$COMPOSE_DIR"/data -type f -exec chmod 664 {} \;

# 5. Iniciar servicio
log "Iniciando contenedor OpenVAS Lite..."
docker-compose up -d >> "$LOG_FILE" 2>&1

# 6. Esperar inicialización con timeout
log "Esperando inicialización (puede tardar hasta 2 horas)..."
while [ $SECONDS -lt $TIMEOUT_INSTALL ]; do
    STATUS=$(docker inspect -f '{{.State.Health.Status}}' openvas-lite 2>/dev/null)
    
    case $STATUS in
        healthy)
            log "OpenVAS Lite está listo!"
            break
            ;;
        starting)
            # Mostrar progreso cada 5 minutos
            if (( $SECONDS % 300 == 0 )); then
                LOG_LINE=$(docker logs --tail=1 openvas-lite 2>&1)
                log "Estado: starting | Último log: $LOG_LINE"
            fi
            sleep 30
            ;;
        *)
            log "Estado inesperado: $STATUS"
            docker logs --tail=20 openvas-lite >> "$LOG_FILE"
            exit 1
            ;;
    esac
done

# 7. Configuración post-instalación
if [ "$STATUS" = "healthy" ]; then
    log "Optimizando configuración..."
    docker exec openvas-lite bash -c "
        echo 'config set scanner.auto_update=false' | openvasmd --server;
        sed -i 's/max_hosts=.*/max_hosts=1/' /etc/openvas/openvassd.conf;
        sed -i 's/max_checks=.*/max_checks=3/' /etc/openvas/openvassd.conf;
        echo 'Optimización completada'" >> "$LOG_FILE" 2>&1
    
    docker-compose restart >> "$LOG_FILE" 2>&1
    
# 8. Mostrar credenciales
    PASS=$(docker exec openvas-lite cat /var/lib/openvas/private/credentials 2>/dev/null | cut -d':' -f2)
    
    echo "=====================================" | tee -a "$LOG_FILE"
    echo "  INSTALACIÓN COMPLETADA CON ÉXITO    " | tee -a "$LOG_FILE"
    echo "=====================================" | tee -a "$LOG_FILE"
    echo "URL de acceso: https://$(curl -s ifconfig.me):9390" | tee -a "$LOG_FILE"
    echo "Usuario: admin" | tee -a "$LOG_FILE"
    echo "Contraseña: ${PASS:-'Generada, ver en /var/lib/openvas/private/credentials'}" | tee -a "$LOG_FILE"
    echo "Log completo: $LOG_FILE" | tee -a "$LOG_FILE"
    echo "=====================================" | tee -a "$LOG_FILE"
else
    log "ERROR: Tiempo de espera agotado (2 horas)"
    log "Últimos logs:"
    docker logs --tail=50 openvas-lite >> "$LOG_FILE"
    echo "Consulte el log completo: $LOG_FILE" >&2
    exit 1
fi
