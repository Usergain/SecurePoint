# Imagen base oficial de Odoo
FROM odoo:16.0

# Instala herramientas útiles
USER root
RUN apt-get update && apt-get install -y \
    git \
    vim \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Copiar entrypoint personalizado
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Puerto expuesto por Odoo
EXPOSE 8069

# Comando de arranque
CMD ["/entrypoint.sh"]
