#!/bin/bash

# Update System
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Create Prometheus User
echo "Creating Prometheus user..."
sudo useradd --no-create-home --shell /bin/false prometheus

# Download Prometheus v2.53.4
echo "Downloading Prometheus v2.53.4..."
cd /opt
wget https://github.com/prometheus/prometheus/releases/download/v2.53.4/prometheus-2.53.4.linux-amd64.tar.gz
sudo tar -xvf prometheus-2.53.4.linux-amd64.tar.gz
sudo mv prometheus-2.53.4.linux-amd64 prometheus

# Set Permissions
echo "Setting permissions..."
sudo chown -R prometheus:prometheus /opt/prometheus

# Create Prometheus Configuration
echo "Configuring Prometheus..."
sudo bash -c 'cat > /opt/prometheus/prometheus.yml <<EOF
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]

  - job_name: "node_exporter"
    static_configs:
      - targets: ["localhost:9100"]
EOF'

# Create Prometheus Systemd Service
echo "Creating Prometheus systemd service..."
sudo bash -c 'cat > /etc/systemd/system/prometheus.service <<EOF
[Unit]
Description=Prometheus Monitoring
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
ExecStart=/opt/prometheus/prometheus --config.file=/opt/prometheus/prometheus.yml --storage.tsdb.path=/opt/prometheus/data
Restart=always

[Install]
WantedBy=multi-user.target
EOF'

# Start Prometheus
echo "Starting Prometheus..."
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

echo "Prometheus v2.53.4 installation and setup completed!"
