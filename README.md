# SecurePoint Systems 🚀

SecurePoint es una infraestructura profesional para la demostración de un entorno seguro de TPVs conectados a sistemas de monitorización de amenazas en la nube.

---

## 📦 Contenidos del Repositorio

| Carpeta         | Contenido                             | Plataforma     |
|:----------------|:--------------------------------------|:---------------|
| `/odoo/`        | Odoo POS - TPV Panadería y Gestión     | Railway        |
| `/monitoring/`  | OpenVAS + Wireshark + Netdata          | Render         |
| `/terraform/`   | Scripts de despliegue en Oracle Cloud  | Oracle Cloud   |

---

## 🛠️ Despliegue

### Odoo POS
- Plataforma: **Railway**
- Ruta: `/odoo/`
- Despliegue: Dockerfile + Variables de entorno (DB_HOST, DB_PORT, DB_USER...)

### Sistema de Monitorización
- Plataforma: **Render**
- Ruta: `/monitoring/`
- Servicios:
  - OpenVAS (escaneos de vulnerabilidades)
  - Wireshark (análisis de red)
  - Netdata (monitorización gráfica de contenedores)

### Alta disponibilidad futura (Oracle)
- Plataforma: **Oracle Cloud Free Tier**
- Ruta: `/terraform/`
- Automatización de instancias: **Terraform**

---

## 🌐 Arquitectura del Proyecto

- **Railway**: TPV Odoo (Alta Disponibilidad)
- **Render**: Sistema de monitorización
- **AWS**: (opcional) Alta disponibilidad futura + Prowler
- **Oracle**: Nodo backup en cloud (cuando haya espacio)

Tecnologías de autenticación:
- OAuth 2.0
- API Key
- SAML (opcional)

---

## 🔥 Visión Final

- Login sencillo para negocios (panaderías, gestorías, etc.)
- Alta disponibilidad y resiliencia cloud
- Monitorización continua de ciberamenazas
- Panel centralizado de control
- Preparado para escalado real a producción 🚀

---

## 👨‍💻 Creditos

Proyecto desarrollado por **SecurePoint Systems** como PoC para Startup + Trabajo Final de Ciclo Formativo ASIX.

---

