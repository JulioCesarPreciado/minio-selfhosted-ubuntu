#!/bin/bash

echo "📦 Instalación de dependencias necesarias para MinIO con NGINX y HTTPS"
echo "--------------------------------------------------------------"

# 🧼 Actualización del sistema
echo "🔄 Actualizando sistema..."
sudo apt update && sudo apt upgrade -y

# 🐳 Instalación de Docker
echo "🐳 Instalando Docker..."
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

# 🧱 Instalación de Docker Compose
echo "🧱 Instalando Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 🌐 Instalación de NGINX
echo "🌐 Instalando NGINX..."
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# 🔐 Instalación de Certbot y plugin para NGINX
echo "🔐 Instalando Certbot + plugin NGINX..."
sudo apt install -y certbot python3-certbot-nginx

# ✅ Finalizado
echo "✅ Instalación completa. Ya puedes correr tu docker-compose y configurar NGINX."
