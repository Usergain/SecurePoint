
# Official Odoo base image
FROM odoo:16.0

# Environment variables for PostgreSQL configuration
ENV POSTGRES_DB=postgres \
    POSTGRES_USER=odoo \
    POSTGRES_PASSWORD=odoo

# Install necessary dependencies (if required)
USER root
RUN apt-get update && apt-get install -y \
    git \
    vim \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Create Odoo data volume
VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

# Port exposed
EXPOSE 8069

# Default command to start Odoo
CMD ["odoo"]
