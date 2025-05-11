# SecurePoint - Grafana + Loki Stack

Este repositorio contiene una configuración funcional de Loki y Grafana, diseñada para integrarse con agentes Promtail desplegados en múltiples instancias de la startup SecurePoint.

## 🚀 Servicios

- **Loki:** Backend para logs.
- **Grafana:** Panel visual para consultas de logs desde múltiples agentes Promtail.

## 📁 Estructura del Proyecto

- `docker-compose.yml`: Lanza Loki y Grafana.
- `loki-config.yaml`: Configuración para la ingesta de logs por Loki.
- `grafana-storage`: Volumen persistente para dashboards y configuraciones.

## 🔧 Instalación

```bash
git clone https://github.com/securepoint/loki-stack.git
cd loki-stack
docker-compose up -d
