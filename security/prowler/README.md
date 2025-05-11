# Prowler AWS Scanner Setup

Este repositorio contiene un script de instalación (`setup.sh`) para desplegar **Prowler v5** en un entorno Ubuntu con Python3 y AWS CLI.

## 🔧 Requisitos

- Ubuntu/Debian con acceso root
- Cuenta de AWS activa
- Usuario IAM con política `SecurityAudit`
- Clave de acceso AWS (`Access Key ID` y `Secret Access Key`)

## 🚀 Instalación

```bash
git clone https://github.com/tu_usuario/tu_repo_prowler.git
cd tu_repo_prowler
chmod +x setup.sh
./setup.sh
```

Durante el proceso se tendra que configurar claves de AWS : https://us-east-1.console.aws.amazon.com/iam/home#/users
AWS Access Key ID     
AWS Secret Access Key 

```bash
aws configure --profile default
```

Luego lanzar la orden:
```bash
prowler aws --service iam ec2 --output-formats csv
```

El script está programado en crontab para que se ejecute cada hora,no obstante se podrá ejecutar de forma mannual
```bash
source prowler-venv/bin/activate
prowler aws --region eu-north-1 --severity critical high --output-formats csv
```

Consultar en Grafana Loki
```bash
{job="prowler"} |= "Scan completed"
```
