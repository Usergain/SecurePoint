
# Imagen base oficial de Odoo
FROM odoo:16.0

# Variables de entorno para configurar PostgreSQL
ENV POSTGRES_DB=postgres \
    POSTGRES_USER=odoo \
    POSTGRES_PASSWORD=odoo

# Instala dependencias necesarias (si fueran requeridas)
USER root
RUN apt-get update && apt-get install -y \
    git \
    vim \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Crear el volumen de datos de Odoo
VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

# Puerto expuesto
EXPOSE 8069

# Comando por defecto para iniciar Odoo
CMD ["odoo"]
