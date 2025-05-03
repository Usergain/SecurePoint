
#!/bin/bash

# --- Configuración OpenVAS Lite (1GB RAM/30GB ROM) ---

# Verificar si ya está instalado
if [ -f ~/.openvas-installed ]; then
  echo "OpenVAS Lite ya está instalado. Ejecutar 'docker-compose up -d' en el directorio."
  exit 0
fi

# Instalar dependencias
echo "Instalando dependencias..."
sudo apt-get update > /dev/null
sudo apt-get install -y docker.io docker-compose curl jq > /dev/null

# Configurar Docker sin sudo
sudo usermod -aG docker $USER
newgrp docker

# Crear estructura de directorios
mkdir -p ~/openvas-lite/{config,data} && cd ~/openvas-lite

# Descargar archivos de configuración
echo "Descargando configuración optimizada..."
curl -sO https://raw.githubusercontent.com/tu-usuario/tpv-seguro/main/openvas-lite/docker-compose.yml
curl -sO https://raw.githubusercontent.com/tu-usuario/tpv-seguro/main/openvas-lite/Dockerfile

# Iniciar servicio (primera vez tarda ~20 mins)
echo "Iniciando OpenVAS Lite (paciencia, primera ejecución tarda)..."
docker-compose up -d

# Esperar hasta que esté HEALTHY
while ! docker ps --filter name=openvas-lite --format '{{.Status}}' | grep -q 'healthy'; do
  echo "Esperando inicialización completa (10s más)..."
  sleep 10
done

# Configuración post-instalación
echo "Optimizando configuración para bajos recursos..."
docker exec -it openvas-lite bash -c "echo 'config set scanner.auto_update=false' | openvasmd --server"
docker exec -it openvas-lite sed -i 's/max_hosts=.*/max_hosts=1/' /etc/openvas/openvassd.conf
docker exec -it openvas-lite sed -i 's/max_checks=.*/max_checks=5/' /etc/openvas/openvassd.conf

# Reiniciar con nueva configuración
docker-compose restart

# Marcar como instalado
touch ~/.openvas-installed

# Mostrar credenciales
echo "¡Instalación completada!"
echo "Acceso Web: https://$(curl -s ifconfig.me):9390"
echo "Usuario: admin"
echo "Contraseña: $(docker exec -it openvas-lite cat /var/lib/openvas/private/credentials | cut -d':' -f2)"
