#!/bin/bash

set -euo pipefail

echo "🚀 Starting DevOps controller setup..."

T_VERSION="1.15.1"

# Detect package manager
if command -v dnf >/dev/null 2>&1; then
    PM="dnf"
elif command -v yum >/dev/null 2>&1; then
    PM="yum"
elif command -v apt-get >/dev/null 2>&1; then
    PM="apt-get"
else
    echo "❌ No supported package manager found"
    exit 1
fi

echo "📦 Using package manager: $PM"

# Install dependencies (ONLY ONCE, safely)
echo "🔧 Installing dependencies..."

if [ "$PM" = "apt-get" ]; then
    sudo apt-get update -y
    sudo apt-get install -y unzip curl git python3 python3-pip
else
    sudo $PM clean all || true
    sudo $PM makecache || true
    sudo $PM update -y

    # Install one-by-one (safe for dnf/yum)
    for pkg in unzip curl git python3 python3-pip; do
        echo "Installing $pkg..."
        if ! sudo $PM install -y $pkg; then
            echo "⚠️ Conflict detected for $pkg → trying fix..."
            sudo $PM install -y $pkg --allowerasing || \
            echo "❌ Failed to install $pkg, skipping..."
        fi
    done
fi

# Ensure pip works
echo "⚙️ Upgrading pip..."
python3 -m pip install --upgrade pip --break-system-packages || true

# Install Ansible
echo "⚙️ Installing Ansible..."

if [ "$PM" = "apt-get" ]; then
    sudo apt-get install -y ansible
else
    sudo $PM install -y ansible || \
    sudo python3 -m pip install ansible
fi
# Install Terraform
echo "⚙️ Installing Terraform..."
curl -fsSL -o /tmp/terraform.zip \
https://releases.hashicorp.com/terraform/${T_VERSION}/terraform_${T_VERSION}_linux_amd64.zip

unzip -o /tmp/terraform.zip -d /tmp
sudo mv /tmp/terraform /usr/local/bin/
rm -f /tmp/terraform.zip

sudo chmod +x /usr/local/bin/terraform

# Verify
echo "✅ Verifying installations..."
terraform -version
ansible --version

echo "🎉 DevOps controller ready!"
