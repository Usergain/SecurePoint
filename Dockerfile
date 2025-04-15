FROM odoo:16.0

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8069

CMD ["/entrypoint.sh"]
