FROM odoo:16.0
COPY odoo.conf /etc/odoo/odoo.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
