#!/bin/bash

set -e

echo "Starting Ansible setup"

# update system
echo "updating package"
sudo yum update -y || sudo apt update -y

#install python3 and pip if not installed

echo "installing python2 & pip..."
sudo yum install -y python3 python3-pip || sudo apt install python3 python3-pip


#install ansible
echo "installing ansible"
pip3 install --user ansible

#add ansible to path(if needed)
export PATH=$PATH:$HOME/.local/bin
echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc

#Verify installation
echo "ansible version"
ansible --version

#create ansible directory structure
echo "Creating ansible directories"

ANSIBLE_DIR="$HOME/ansible"
INVENTORY_DIR="$ANSIBLE_DIR/inventory"

mkdir -p "$INVENTORY_DIR"

#create ansible.cfg 
echo "creating ansible.cfg"
cat <<EOF > ~/ansible/ansible.cfg
[defaults]
inventory = ./inventory/hosts
host_key_checking = False
remote_user = ec2-user
private_key_file = ~/terraform_key.pem
retry_files_enabled = False
EOF


# Create sample inventory
echo "🖥️ Creating sample inventory..."
cat <<EOF > "$INVENTORY_DIR/hosts"
[master]
<MASTER_PUBLIC_IP>

[workers]
<WORKER1_PUBLIC_IP>
<WORKER2_PUBLIC_IP>
EOF

# Set correct permission for key
# Set correct permission for key
echo "🔐 Setting key permissions..."

KEY_PATH="$HOME/terraform_key.pem"

if [ -f "$KEY_PATH" ]; then
  chmod 400 "$KEY_PATH"
  echo "✅ Key permission set: $KEY_PATH"
else
  echo "⚠️ terraform_key.pem not found at $KEY_PATH"

  # Get instance public IP dynamically (works inside EC2)
  INSTANCE_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 || echo "YOUR_EC2_PUBLIC_IP")

  echo ""
  echo "👉 Copy the key from your LOCAL machine using:"
  echo "scp -i terraform_key.pem terraform_key.pem ec2-user@$INSTANCE_IP:/home/ec2-user/"
  echo ""
fi

#completion massage

echo "Ansible setup completed"
echo "Update inventory with hosts ip"

