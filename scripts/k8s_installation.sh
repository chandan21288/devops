#! /bin/bash

set -e

echo "Updating packages....."

if commnad -v apt >/dev/null 2<&1; then
    PKG_MANAGER="apt"
elif command -v dnf >/dev/null 2<&1; then
    PKG_MANAGER="dnf"
elif command -v yum >/dev/null 2<&1; then
    PKG_MANAGER="yum"
else
    echo "Unsupported linux distribution"
    exit 1
fi

# Docker installation
echo "Starting docker installation"

sudo systemctl enable docker 
sudo systemctl start docker 
sudo usermod -aG docker $USER

#Kubectl installation

echo "Starting kubectl installation"

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl
sudo mv kubectl /usr/local/bin/


#install minikube

echo "installing minikube"

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube


#Verify installation

echo "Docker version"
docker --version

echo "kubectl version"
kubectl version --client

echo "Minikube version"
minikube version


#Start kubernetes cluster

echo "Starting minikube cluster"

minikube start --driver=docker

# verify Cluster

echo "Cluster nodes"
kubectl get nodes


echo ""
echo "Kubernetes setup completed successfully."
echo ""
echo "IMPORTANT:"
echo "Please logout and login again for docker group changes to take effect."

