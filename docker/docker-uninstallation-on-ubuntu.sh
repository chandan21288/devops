#!/bin/bash

set -e 

echo "==> stoping docker services"
sudo systemctl stop docker || true
sudo systemctl stop containerd || true

echo "==> Uninstalling Docker packages..."
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "==> Removing Docker dependencies..."
sudo apt-get autoremove -y --purge

echo "==> Removing Docker files and directories..."
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
sudo rm -rf /etc/docker
sudo rm -f /etc/apt/sources.list.d/docker.list
sudo rm -rf /etc/apt/keyrings/docker.gpg

echo "==> Docker successfully uninstalled."