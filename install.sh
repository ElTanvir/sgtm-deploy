#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=======================================${NC}"
echo -e "${GREEN}   sGTM Hosting Panel Installer        ${NC}"
echo -e "${GREEN}=======================================${NC}"

# 1. Check Root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run as root (sudo ./install.sh)${NC}"
  exit 1
fi

# 2. Check/Install Docker
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    echo -e "${GREEN}Docker installed successfully.${NC}"
else
    echo "Docker is already installed."
fi

# 3. User Configuration
read -p "Enter Admin Username (default: admin): " ADMIN_USER
ADMIN_USER=${ADMIN_USER:-admin}

read -s -p "Enter Admin Password: " ADMIN_PASSWORD
echo ""
while [ -z "$ADMIN_PASSWORD" ]; do
    echo -e "${RED}Password cannot be empty.${NC}"
    read -s -p "Enter Admin Password: " ADMIN_PASSWORD
    echo ""
done

# 4. Generate SSL Certificates (Self-Signed)
echo "Checking SSL Certificates..."
mkdir -p certs
if [ ! -f certs/server.key ] || [ ! -f certs/server.crt ]; then
    echo "Generating self-signed certificate for initial setup..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout certs/server.key -out certs/server.crt \
        -subj "/C=US/ST=State/L=City/O=sGTM/CN=localhost"
    chmod 644 certs/server.key certs/server.crt
    echo -e "${GREEN}Certificates generated in ./certs${NC}"
else
    echo "Certificates already exist."
fi

# 5. Start Services
echo "Starting services via Docker Compose..."
export ADMIN_USER="$ADMIN_USER"
export ADMIN_PASSWORD="$ADMIN_PASSWORD"

# Use 'docker compose' (v2) or 'docker-compose' (v1)
if docker compose version &> /dev/null; then
    docker compose up -d
elif command -v docker-compose &> /dev/null; then
    docker-compose up -d
else
    echo -e "${RED}Docker Compose plugin not found. Please install it.${NC}"
    exit 1
fi

echo -e "${GREEN}=======================================${NC}"
echo -e "${GREEN}Installation Complete!${NC}"
echo -e "Access your panel at:"
echo -e "  HTTP:  http://YOUR_SERVER_IP"
echo -e "  HTTPS: https://YOUR_SERVER_IP (Accept security warning for self-signed cert)"
echo -e "${GREEN}=======================================${NC}"
