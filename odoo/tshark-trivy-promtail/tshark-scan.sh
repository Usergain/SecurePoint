#!/bin/bash

# Evita llenar disco: limpia si > 50MB
LOG_PATH="/var/log/tshark.log"
if [ -f "$LOG_PATH" ] && [ $(du -m "$LOG_PATH" | cut -f1) -ge 50 ]; then
  echo "" > "$LOG_PATH"
fi

# Captura tráfico en puerto 8069 (Odoo)
tshark -i any -f "port 8069" -c 1000 >> "$LOG_PATH" 2>&1
