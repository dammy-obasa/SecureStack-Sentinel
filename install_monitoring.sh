#!/bin/bash
# Automated script to install Prometheus, Grafana, and exporters on Ubuntu-based systems

# Update system and install dependencies
sudo apt update -y
sudo apt install wget -y

# Install Prometheus
mkdir -p /etc/prometheus
cd /etc/prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.46.0/prometheus-2.46.0.linux-amd64.tar.gz
tar -xvzf prometheus-2.46.0.linux-amd64.tar.gz
sudo mv prometheus-2.46.0.linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-2.46.0.linux-amd64/promtool /usr/local/bin/

# Create Prometheus configuration
cat << EOF | sudo tee /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
EOF

# Create Prometheus systemd service
sudo tee /etc/systemd/system/prometheus.service > /dev/null << EOF
[Unit]
Description=Prometheus Server
After=network-online.target
[Service]
ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml
[Install]
WantedBy=multi-user.target
EOF

# Start Prometheus
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

# Install Apache exporter
wget https://github.com/Lusitaniae/apache_exporter/releases/download/v0.10.1/apache_exporter-0.10.1.linux-amd64.tar.gz
tar xzf apache_exporter-0.10.1.linux-amd64.tar.gz
sudo mv apache_exporter-0.10.1.linux-amd64/apache_exporter /usr/local/bin/
nohup apache_exporter --telemetry.address=:9117 --telemetry.endpoint=/metrics &

# Install Grafana
sudo apt install -y software-properties-common
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo apt update
sudo apt install -y grafana

# Start Grafana
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
