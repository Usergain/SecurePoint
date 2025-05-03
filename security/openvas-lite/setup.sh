#!/bin/bash

# --- Configuración OpenVAS Lite (1GB RAM/30GB ROM) ---

# 1. Verificar si es root o usar sudo
if [ "$(id -u)" -ne 0 ]; then
  echo "Requeridos permisos de administrador. Ejecutando con sudo..."
  exec sudo bash "$0" "$@"
  exit $?
fi

# 2. Verificar si ya está instalado
if [ -f /root/.openvas-installed ]; then
  echo "OpenVAS Lite ya está instalado."
  echo "Ejecutar 'cd ~/SecurePoint/security/openvas-lite && docker-compose up -d'"
  exit 0
fi

# 3. Configurar logging completo
LOG_FILE="/var/log/openvas-install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=== Inicio de instalación $(date) ==="

# 4. Instalar dependencias con verificación
echo -n "Instalando dependencias... "
apt-get update && apt-get install -y \
    docker.io \
    docker-compose \
    curl \
    jq \
    git \
    uidmap \
    >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
  echo "Éxito"
else
  echo "Fallo! Ver /var/log/openvas-install.log"
  exit 1
fi

# 5. Configurar Docker en modo rootless (más seguro)
echo "Configurando Docker rootless..."
systemctl stop docker
dockerd-rootless-setuptool.sh install
systemctl start docker

# 6. Crear estructura de directorios
echo "Creando directorios..."
mkdir -p /opt/SecurePoint/security/openvas-lite/{config,data}
cd /opt/SecurePoint/security/openvas-lite

# 7. Descargar configuración desde GitHub
echo "Descargando configuración..."
curl -sO https://raw.githubusercontent.com/tu-usuario/SecurePoint/main/security/openvas-lite/docker-compose.yml
curl -sO https://raw.githubusercontent.com/tu-usuario/SecurePoint/main/security/openvas-lite/Dockerfile

# 8. Iniciar servicio
echo "Iniciando OpenVAS Lite (paciencia)..."
docker-compose up -d &

# 9. Monitorizar progreso
while ! docker ps --filter name=openvas-lite --format '{{.Status}}' | grep -q 'healthy'; do
  echo "Estado: $(docker inspect -f '{{.State.Status}}' openvas-lite)"
  sleep 30
done

# 10. Configuración post-instalación
echo "Optimizando configuración..."
docker exec openvas-lite bash -c "echo 'config set scanner.auto_update=false' | openvasmd --server"
docker exec openvas-lite sed -i 's/max_hosts=.*/max_hosts=1/' /etc/openvas/openvassd.conf
docker exec openvas-lite sed -i 's/max_checks=.*/max_checks=5/' /etc/openvas/openvassd.conf
docker-compose restart

# 11. Marcar como instalado
touch /root/.openvas-installed

# 12. Mostrar credenciales
echo "=== Instalación completada ==="
echo "URL: https://$(curl -s ifconfig.me):9390"
echo "Usuario: admin"
echo "Contraseña: $(docker exec openvas-lite cat /var/lib/openvas/private/credentials | cut -d':' -f2)"
echo "Log completo: $LOG_FILE"
