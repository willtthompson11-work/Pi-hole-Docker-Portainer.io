#!/usr/bin/env bash
set -e

echo "[*] Creating persistent volume for Portainer..."
docker volume create portainer_data

echo "[*] Deploying Portainer CE on port 9443..."
docker run -d \
  -p 9443:9443 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest

echo "[*] Deploying Pi-hole DNS Sinkhole on ports 53 & 8080..."
docker run -d \
  --name pihole \
  -p 53:53/tcp -p 53:53/udp \
  -p 8080:80 \
  -e TZ="America/Phoenix" \
  -v pihole_data:/etc/pihole \
  -v pihole_dnsmasq:/etc/dnsmasq.d \
  --restart=unless-stopped \
  pihole/pihole:latest

echo "[+] Deployment complete. Run 'docker exec -it pihole pihole setpassword' to configure admin credentials."
