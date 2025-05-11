# 🚀 SecurePoint Systems

**SecurePoint** es una infraestructura profesional diseñada para auditar, monitorizar y proteger entornos de TPV conectados a la nube. Este proyecto nace como solución para startups del sector financiero y comercial que buscan implementar medidas avanzadas de ciberseguridad sin depender de grandes inversiones iniciales.

> 💡 Proyecto desarrollado como Trabajo de Fin de Grado (TFG) en ASIX – con proyección real de despliegue.

---

## 📂 Estructura del Repositorio

| Carpeta                   | Contenido                                          | Plataforma         |
|---------------------------|----------------------------------------------------|---------------------|
| `/odoo`                   | TPV Panadería + Odoo POS (Docker)                  | Instancia AWS EC2   |
| `/tshark-trivy-promtail` | Monitorización de tráfico y escaneos de seguridad  | Instancia AWS EC2   |
| `/security/prowler`      | Auditoría de AWS con Prowler                       | Instancia AWS EC2   |
| `/monitoring/loki-grafana` | Centralización de logs con Loki + Grafana       | Instancia AWS EC2   |

---

## ⚙️ Despliegue por Componentes

### 🧾 Odoo POS

- **Plataforma**: EC2 (Ubuntu 22.04)  
- **Ruta**: `/odoo/`  
- **Funcionalidad**:  
  TPV funcional para demostración de panaderías, incluye artículos y configuración desde Odoo v17.  
- **Tecnología**: Docker Compose, PostgreSQL, SMTP  
- **Documentación**: [Ver aquí](./odoo/README.md)

---

### 🔒 Auditoría de Seguridad

#### 🔹 AWS + Prowler

- **Ruta**: `/security/prowler/`
- **Funcionalidad**:  
  Se ejecutan escaneos programados sobre una cuenta AWS utilizando Prowler, y los resultados se visualizan en Loki.
- **Tecnología**: Python, Virtualenv, Systemd, Logger
- **Integración con Promtail**: ✅  
- **Documentación**: [Ver aquí](./security/prowler/README.md)

#### 🔹 Escaneo de Imagen Docker con Trivy

- **Ruta**: `/tshark-trivy-promtail/`  
- **Funcionalidad**:  
  Escanea la imagen de Odoo cada 6h buscando vulnerabilidades críticas/altas y las reporta vía Promtail.
- **Tecnología**: Trivy, Systemd, Logs personalizados  
- **Documentación**: [Ver aquí](./tshark-trivy-promtail/README.md)

---

### 🌐 Monitorización de Red

#### 🔸 TShark

- **Ruta**: `/tshark-trivy-promtail/`
- **Funcionalidad**:  
  Captura tráfico del puerto 8069 (interfaz web Odoo) con rotación automática de logs.
- **Visualización en Loki**: ✅  
- **Documentación**: [Ver aquí](./tshark-trivy-promtail/README.md)

---

### 📊 Grafana + Loki

- **Ruta**: `/monitoring/loki-grafana/`  
- **Funcionalidad**:  
  Interfaz web para explorar logs centralizados de Prowler, Trivy y TShark con filtros por job.
- **Visualización Real**:  
  Acceso a http://<ip>:3000 y login `admin/securepoint2025`  
- **Tecnología**: Docker Compose, Persistencia con volúmenes
- **Documentación**: [Ver aquí](./monitoring/loki-grafana/README.md)

---

## 🔁 Automatización

Todos los servicios utilizan `systemd` + `timers` para lanzar escaneos o capturas cada X horas. Esto incluye:

- `prowler-scan.service` → Cada 1h
- `trivy-scan.service` → Cada 6h
- `tshark-loop.service` → En bucle con rotación
- `promtail.service` → Reenvío continuo a Loki

---

## 🧠 Aprendizajes

- Integración avanzada de herramientas de seguridad en la nube
- Uso eficiente de recursos en entornos de baja RAM (1GB)
- Centralización y análisis de logs distribuidos
- Monitorización en tiempo real de escaneos y tráfico

---

## 📸 Capturas recomendadas (para memoria TFG)

| Módulo       | Descripción                    | Comando para generar captura |
|--------------|--------------------------------|-------------------------------|
| Grafana Logs | `job="prowler"` + Wrap lines  | `journalctl -u prowler-scan` |
| Trivy Scan   | `job="trivy"` + tabla          | `journalctl -u trivy-scan`   |
| TShark Live  | `job="tshark"` + scroll        | `tail -f /var/log/tshark.log`|

---

## 🧠 Contacto

> Proyecto desarrollado por el equipo de **SecurePoint Systems** como parte del Trabajo de Fin de Grado del ciclo ASIX (Administración de Sistemas Informáticos en Red).

---
