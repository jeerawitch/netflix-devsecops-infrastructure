#!/bin/bash

set -e

PROMETHEUS_VERSION="3.13.2"
NODE_EXPORTER_VERSION="1.12.1"

echo "======================================"
echo " Installing Monitoring Stack"
echo " Prometheus + Node Exporter + Grafana"
echo "======================================"


# =========================================================
# Prometheus
# =========================================================

echo ""
echo "===== Creating Prometheus User ====="

sudo useradd \
  --system \
  --no-create-home \
  --shell /bin/false \
  prometheus 2>/dev/null || true


echo "===== Downloading Prometheus ====="

wget -q \
  https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz


echo "===== Extracting Prometheus ====="

tar -xzf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz

cd prometheus-${PROMETHEUS_VERSION}.linux-amd64


echo "===== Creating Prometheus Directories ====="

sudo mkdir -p /data
sudo mkdir -p /etc/prometheus


echo "===== Installing Prometheus ====="

sudo mv prometheus /usr/local/bin/
sudo mv promtool /usr/local/bin/
sudo mv prometheus.yml /etc/prometheus/prometheus.yml


echo "===== Setting Prometheus Permissions ====="

sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /data

sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool


echo "===== Creating Prometheus Systemd Service ====="

sudo tee /etc/systemd/system/prometheus.service > /dev/null <<'EOF'
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s

ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/data \
  --web.listen-address=0.0.0.0:9090 \
  --web.enable-lifecycle

[Install]
WantedBy=multi-user.target
EOF


echo "===== Cleaning Prometheus Files ====="

cd ..

rm -rf prometheus-${PROMETHEUS_VERSION}.linux-amd64
rm -f prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz



# =========================================================
# Node Exporter
# =========================================================

echo ""
echo "===== Creating Node Exporter User ====="

sudo useradd \
  --system \
  --no-create-home \
  --shell /bin/false \
  node_exporter 2>/dev/null || true


echo "===== Downloading Node Exporter ====="

wget -q \
  https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz


echo "===== Extracting Node Exporter ====="

tar -xzf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz


echo "===== Installing Node Exporter ====="

sudo mv \
  node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter \
  /usr/local/bin/


echo "===== Setting Node Exporter Permissions ====="

sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter


echo "===== Cleaning Node Exporter Files ====="

rm -rf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64
rm -f node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz


echo "===== Creating Node Exporter Systemd Service ====="

sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<'EOF'
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s

ExecStart=/usr/local/bin/node_exporter --collector.logind

[Install]
WantedBy=multi-user.target
EOF



# =========================================================
# Grafana
# =========================================================

echo ""
echo "===== Installing Grafana Dependencies ====="

sudo apt-get update

sudo apt-get install -y \
  apt-transport-https \
  wget \
  gnupg


echo "===== Creating Grafana Keyring Directory ====="

sudo mkdir -p /etc/apt/keyrings


echo "===== Adding Grafana GPG Key ====="

sudo wget \
  -O /etc/apt/keyrings/grafana.asc \
  https://apt.grafana.com/gpg-full.key

sudo chmod 644 /etc/apt/keyrings/grafana.asc


echo "===== Adding Grafana Repository ====="

echo "deb [signed-by=/etc/apt/keyrings/grafana.asc] https://apt.grafana.com stable main" \
  | sudo tee /etc/apt/sources.list.d/grafana.list > /dev/null


echo "===== Updating Package List ====="

sudo apt-get update


echo "===== Installing Grafana ====="

sudo apt-get install -y grafana



# =========================================================
# Prometheus Configuration
# =========================================================

echo ""
echo "===== Configuring Prometheus ====="

sudo tee /etc/prometheus/prometheus.yml > /dev/null <<'EOF'
global:
  scrape_interval: 15s

scrape_configs:

  - job_name: "prometheus"
    static_configs:
      - targets:
          - "localhost:9090"

  - job_name: "node_exporter"
    static_configs:
      - targets:
          - "localhost:9100"

  - job_name: 'jenkins'
    metrics_path: '/prometheus/'
    static_configs:
      - targets: ['<your-jenkins-ip>:<your-jenkins-port>']

  - job_name: 'eks_node_exporter'
    metrics_path: '/metrics'
    static_configs:
      - targets: ['<your-eks-ip>:9100']
EOF


echo "===== Checking Prometheus Configuration ====="

sudo /usr/local/bin/promtool check config /etc/prometheus/prometheus.yml



# =========================================================
# Reload Systemd
# =========================================================

echo ""
echo "===== Reloading Systemd ====="

sudo systemctl daemon-reload



# =========================================================
# Enable Services
# =========================================================

echo ""
echo "===== Enabling Services ====="

sudo systemctl enable prometheus
sudo systemctl enable node_exporter
sudo systemctl enable grafana-server



# =========================================================
# Start Services
# =========================================================

echo ""
echo "===== Starting Services ====="

sudo systemctl restart prometheus
sudo systemctl restart node_exporter
sudo systemctl restart grafana-server



# =========================================================
# Status
# =========================================================

echo ""
echo "===== Prometheus Status ====="

sudo systemctl status prometheus --no-pager


echo ""
echo "===== Node Exporter Status ====="

sudo systemctl status node_exporter --no-pager


echo ""
echo "===== Grafana Status ====="

sudo systemctl status grafana-server --no-pager



# =========================================================
# Complete
# =========================================================

echo ""
echo "======================================"
echo " Monitoring Stack Installation Complete"
echo "======================================"
echo ""
echo " Prometheus    : http://SERVER_IP:9090"
echo " Node Exporter : http://SERVER_IP:9100"
echo " Grafana       : http://SERVER_IP:3000"
echo ""
echo " Grafana default login:"
echo " Username: admin"
echo " Password: admin"
echo ""
echo "======================================"