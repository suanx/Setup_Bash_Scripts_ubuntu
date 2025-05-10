#!/bin/bash

# Update System
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Create Node Exporter User
echo "Creating Node Exporter user..."
sudo useradd --no-create-home --shell /bin/false node_exporter

# Download & Extract Node Exporter v1.9.1
echo "Downloading Node Exporter v1.9.1..."
cd /opt
wget https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-amd64.tar.gz
sudo tar -xvf node_exporter-1.9.1.linux-amd64.tar.gz
sudo mv node_exporter-1.9.1.linux-amd64 node_exporter

# Set Permissions
echo "Setting permissions..."
sudo chown -R node_exporter:node_exporter /opt/node_exporter

# Create Node Exporter Systemd Service
echo "Creating Node Exporter systemd service..."
sudo bash -c 'cat > /etc/systemd/system/node_exporter.service <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
ExecStart=/opt/node_exporter/node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF'

# Start Node Exporter
echo "Starting Node Exporter..."
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

echo "Node Exporter v1.9.1 installation and setup completed!"
