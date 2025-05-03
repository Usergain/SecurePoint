FROM alpine:latest

# Instalar Suricata + dependencias
RUN apk add --no-cache suricata jq

# Directorio de trabajo
WORKDIR /var/lib/suricata

# Script de inicio
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
