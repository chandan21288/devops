#!/bin/bash

set -e

echo "======================================"
echo " Kubernetes Cleanup Started"
echo "======================================"

# ------------------------------------------
# Delete Minikube Cluster
# ------------------------------------------

echo ""
echo "Deleting Minikube cluster..."

minikube delete 2>/dev/null || true

# ------------------------------------------
# Stop And Remove Containers
# ------------------------------------------

echo ""
echo "Removing Docker containers..."

docker rm -f $(docker ps -aq) 2>/dev/null || true

# ------------------------------------------
# Remove Unused Docker Resources
# ------------------------------------------

echo ""
echo "Cleaning Docker system..."

docker system prune -af --volumes || true

# ------------------------------------------
# Remove Kubernetes Configs
# ------------------------------------------

echo ""
echo "Removing Kubernetes configs..."

rm -rf ~/.kube
rm -rf ~/.minikube

# ------------------------------------------
# Remove Docker CLI Plugins
# ------------------------------------------

echo ""
echo "Removing Docker plugins..."

rm -f ~/.docker/cli-plugins/docker-compose
rm -f ~/.docker/cli-plugins/docker-buildx

# ------------------------------------------
# Optional Binary Cleanup
# Uncomment if full cleanup needed
# ------------------------------------------

 echo ""
 echo "Removing kubectl and minikube binaries..."

 sudo rm -f /usr/local/bin/kubectl
 sudo rm -f /usr/local/bin/minikube

# ------------------------------------------
# Docker Cleanup
# ------------------------------------------

echo ""
echo "Cleaning dangling Docker networks..."

docker network prune -f || true

# ------------------------------------------
# Final Status
# ------------------------------------------

echo ""
echo "======================================"
echo " Cleanup Completed Successfully"
echo "======================================"

echo ""
echo "Remaining Docker Containers:"
docker ps -a || true

echo ""
echo "Remaining Docker Images:"
docker images || true