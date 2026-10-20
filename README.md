# Pi-hole-Docker-Portainer.io
Ubuntu 26.04.1 VM running equipped with Pi-Hole and Docker.

# Containerized DNS Sinkhole & Docker Management Lab (Pi-hole + Portainer)

## Overview
This project documents the deployment of a self-hosted, containerized network infrastructure lab running on **Ubuntu Server 26.04.1 LTS** inside **Oracle VirtualBox**. It utilizes **Docker CE** to host **Pi-hole** as a local network DNS sinkhole for ad/telemetry blocking and **Portainer CE** for visual container lifecycle management.

## Architecture & Topology
- **Host Virtualization:** Oracle VirtualBox (Bridged Networking on `192.168.0.0/24`)
- **Guest OS:** Ubuntu Server 26.04.1 LTS (Kernel `7.0.0-38-generic x86_64`)
- **Static IP Configuration:** `192.168.0.130/24` configured via Netplan (`enp0s3`)
- **Container Runtime:** Docker Engine + Portainer CE (`:9443`)
- **DNS Sinkhole:** Pi-hole (`:53` TCP/UDP, Web Admin on `:8080`)

## Key Features Implemented
1. **Permanent Static IP Routing:** Bypassed DHCP lease drift by configuring a static IPv4 profile directly in `/etc/netplan/01-netcfg.yaml` with Cloudflare (`1.1.1.1`) and Google (`8.8.8.8`) upstream bootstrap resolvers.
2. **Visual Container Orchestration:** Deployed Portainer CE bound to the host Docker socket (`/var/run/docker.sock`) with persistent volume storage and HTTPS enforcement on port `9443`.
3. **DNS Sinkhole & Telemetry Filtering:** Deployed Pi-hole configured to permit cross-subnet/LAN origins across the Docker bridge, intercepting over 71,000+ known advertising, tracking, and telemetry domains (`0.0.0.0` sinkhole response).
4. **Endpoint Validation:** Verified DNS resolution and sinkhole behavior via Windows 11 PowerShell (`nslookup`, `ipconfig /flushdns`) and live query logging.

## Port Mappings
| Service | Host Port | Container Port | Protocol | Description |
| :--- | :--- | :--- | :--- | :--- |
| **Portainer** | `9443` | `9443` | TCP | HTTPS Web Management UI |
| **Pi-hole** | `53` | `53` | TCP / UDP | DNS Server |
| **Pi-hole** | `8080` | `80` | TCP | Pi-hole Web Admin Dashboard (`/admin`) |

## Quick Start / Reproduction

### 1. Apply Static IP via Netplan
Copy `configs/01-netcfg.yaml.example` to `/etc/netplan/01-netcfg.yaml`, adjust for your subnet, lock down permissions, and test:
```bash
sudo chmod 600 /etc/netplan/01-netcfg.yaml
sudo netplan try
```
## Lab Screenshots
![Pi-hole Dashboard](Pi-hole%20dashboard.png)
![Portainer Containers](Screenshot%202026-10-19%20212404.png)
