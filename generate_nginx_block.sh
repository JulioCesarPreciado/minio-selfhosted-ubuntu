#!/bin/bash

# 🧾 Valores por defecto
DOMAIN=""
PORT=""
SAVE_PATH="/etc/nginx/sites-available"

# 🧠 Parsear argumentos tipo --key=value
for arg in "$@"; do
  case $arg in
    --domain=*)
      DOMAIN="${arg#*=}"
      ;;
    --port=*)
      PORT="${arg#*=}"
      ;;
    --path=*)
      SAVE_PATH="${arg#*=}"
      ;;
    *)
      echo "❌ Opción no reconocida: $arg"
      exit 1
      ;;
  esac
done

# 📝 Preguntar datos si no fueron pasados como argumento
if [ -z "$DOMAIN" ]; then
  read -p "🌐 Dominio (ej. minio.yourdomain.com): " DOMAIN
fi

if [ -z "$PORT" ]; then
  read -p "🔌 Puerto destino local (ej. 9001): " PORT
fi

read -p "📁 Ruta para guardar archivo (default: $SAVE_PATH): " INPUT_PATH
SAVE_PATH=${INPUT_PATH:-$SAVE_PATH}

NGINX_FILE="${SAVE_PATH}/${DOMAIN}"

# 📄 Crear configuración NGINX
cat > "$NGINX_FILE" <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    location / {
        proxy_pass http://localhost:$PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

echo "✅ Archivo creado en: $NGINX_FILE"

# 🔗 Crear enlace si se usa sites-enabled
if [ -d "/etc/nginx/sites-enabled" ]; then
  ln -sfn "$NGINX_FILE" "/etc/nginx/sites-enabled/$DOMAIN"
  echo "🔗 Enlace creado en /etc/nginx/sites-enabled/"
fi

# 🔄 Recargar NGINX
echo "♻️ Recargando NGINX..."
sudo systemctl reload nginx

echo "🚀 Todo listo. Accede a: http://$DOMAIN"
