# SecurePoint
creation of a project for POS securization

# Odoo + PostgreSQL Docker Setup

This project includes a complete infrastructure with Odoo 16 and PostgreSQL using Docker Compose.

## ✅ Requirements

- Docker
- Docker Compose
- Account in Railway, Render, Fly.io or local environment.

## 📁 Structure

- `.docker-compose.yml` - Defines Odoo and PostgreSQL services
- `.env` - environment variables (user, database, password)
- `/addons/` - Optional folder for your custom modules

## 🚀 How to build the local environment

```bash
docker-compose up -d
```

Access from your browser to:

```
http://localhost:8069
```

## 🌐 How to deploy it in Railway (100% free)

1. Go to https://railway.app
2. Create a new project > ``Deploy from GitHub``.
3. Plug in your repository that has this `docker-compose.yml`
4. Railway will detect the file and automatically deploy it.
5. Open port `8069` in Railway (in Settings > Networking)
6. Log in to Odoo using the subdomain provided by Railway.

## 🧠 Default data.

- PostgreSQL:
  - DB: `odoo`
  - USER: `odoo`
  - PASSWORD: `odoo`

You can change these values in `.env`

---

This environment supports multiple Odoo databases (`Star Bakery`, `SME`, etc.) and starts automatically every time the server is restarted.

Translated with DeepL.com (free version)
