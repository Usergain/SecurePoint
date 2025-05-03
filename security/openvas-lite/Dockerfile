# openvas-lite/Dockerfile
FROM alpine:latest

RUN apk add --no-cache \
    openvas-scanner \
    openvas-smb \
    && openvas-setup \
    && sed -i 's/auto_update=yes/auto_update=no/' /etc/openvas/openvas.conf \
    && echo "config set scanner.auto_update=false" | openvasmd --server

EXPOSE 9390

CMD ["openvas-start"]
