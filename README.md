
# 📦 MinIO + NGINX + Certbot Setup on Ubuntu Server 22+

This project helps you easily deploy a **MinIO** instance with **NGINX as a reverse proxy** and optional HTTPS support using **Certbot**, all powered by **Docker**.

---

## ✅ Requirements

- Ubuntu Server 22.04 or higher
- A domain pointing to your server (e.g. `minio.yourdomain.com`)
- Root or sudo access

---

## 📁 Project Structure

```
minio-setup/
├── install_dependencies.sh         # Installs Docker, NGINX, and Certbot (optional if already installed)
├── docker-compose.yml             # Contains the MinIO stack
├── generate_nginx_block.sh        # Automatically generates the NGINX configuration for the domain
```

---

## 🚀 Deployment Steps

### 1️⃣ (Optional) Install dependencies

If you’re working on a clean server without Docker, NGINX or Certbot, run:

```bash
chmod +x install_dependencies.sh
./install_dependencies.sh
```

This will install:
- Docker
- Docker Compose
- NGINX
- Certbot + NGINX plugin

---

### 2️⃣ Start MinIO with Docker

Ensure the `docker-compose.yml` file is ready. Then start MinIO:

```bash
docker compose up -d
```

This will expose:
- `9000`: S3 API
- `9001`: Web console

---

### 3️⃣ Generate NGINX configuration

This script will automatically generate a WebSocket-ready NGINX config for your domain:

```bash
chmod +x generate_nginx_block.sh
./generate_nginx_block.sh --domain=minio.yourdomain.com --port=9001
```

This will:
- Create the config file under `/etc/nginx/sites-available/`
- Link it in `sites-enabled/`
- Reload NGINX

---

### 4️⃣ (Optional) Enable HTTPS with Certbot

If your domain is already pointing correctly to your server:

```bash
sudo certbot --nginx -d minio.yourdomain.com
```

Certbot will:
- Generate the SSL certificate
- Insert the `listen 443 ssl;` block automatically
- Reload NGINX

---

## 🌐 Final Result

Access MinIO via:

```
http://minio.yourdomain.com       # If HTTPS is not enabled
https://minio.yourdomain.com      # If HTTPS is enabled via Certbot
```

---

## 🧠 Notes

- The `generate_nginx_block.sh` script includes WebSocket support (`proxy_http_version 1.1` + required headers).
- MinIO requires WebSocket to properly display and browse objects.
- Username and password defaults are set in the `docker-compose.yml`.
