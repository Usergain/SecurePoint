# Official Odoo base image
FROM odoo:16.0

# Environment variables for PostgreSQL configuration
ENV POSTGRES_DB=postgres \
    POSTGRES_USER=odoo \
    POSTGRES_PASSWORD=odoo

# Instala herramientas útiles (opcional)
USER root
RUN apt-get update && apt-get install -y \
    git \
    vim \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# ⚠️ NO USAR VOLUME con Railway
# VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

# Puerto de exposición
EXPOSE 8069

# Comando por defecto
CMD ["odoo"]
