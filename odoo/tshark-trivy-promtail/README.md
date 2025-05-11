# 🔒 Trivy + Promtail + Grafana Loki Integration

Este repositorio contiene la automatización de escaneos de seguridad en imágenes Docker utilizando [Trivy](https://github.com/aquasecurity/trivy), con envío automático de resultados a Grafana Loki mediante Promtail. Pensado para entornos auto-monitorizados de forma periódica y sin intervención manual.

## 🚀 Requisitos

- Ubuntu/Debian
- Docker y Trivy instalados
- Instancia Loki+Grafana accesible vía IP
- Promtail instalado
- Imagen Docker activa (en este caso: `odoo-odoo`)
- Acceso root

## 📦 Archivos

- `trivy-scan.sh`: Script que lanza el escaneo y lo envía a syslog
- `trivy-scan.service`: Servicio systemd que ejecuta el script
- `trivy-scan.timer`: Temporizador para ejecutar el escaneo cada hora
- `promtail-config.yaml`: Configuración de Promtail

## ⚙️ Instalación

### 1. Copiar los scripts

```bash
sudo cp trivy-scan.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/trivy-scan.sh
```

