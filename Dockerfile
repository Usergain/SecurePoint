# Official Odoo base image
FROM odoo:16.0

# Variables de entorno esperadas por Odoo
ENV DB_HOST=postgres \
    DB_PORT=5432 \
    DB_USER=odoo \
    DB_PASSWORD=odoo

# Instala herramientas útiles
USER root
RUN apt-get update && apt-get install -y \
    git \
    vim \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# ⚠️ No usar volumes con Railway
# VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

# Puerto expuesto
EXPOSE 8069

# Comando por defecto
CMD ["odoo"]

