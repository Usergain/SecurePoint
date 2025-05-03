#!/bin/bash
# Instalar Prowler (no requiere Docker)
sudo apt-get install -y python3 python3-pip
pip3 install prowler-cloud
echo "Ejecutar auditoría con: prowler -c check13 (ejemplo)"
