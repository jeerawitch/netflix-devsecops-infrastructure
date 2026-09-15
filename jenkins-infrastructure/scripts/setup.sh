#!/bin/bash

set -e

echo "======================================"
echo " DevSecOps Tools Installation"
echo " Docker + Java + Jenkins + Trivy"
echo "======================================"

# =========================================================
# 1. Update system & install common dependencies
# =========================================================

echo "===== [1/6] Installing dependencies ====="

sudo apt-get update

sudo apt-get install -y \
  ca-certificates \
  curl \
  wget \
  gnupg \
  fontconfig


# =========================================================
# 2. Install Docker
# =========================================================

echo "===== [2/6] Installing Docker ====="

# Create directory for repository keys
sudo install -m 0755 -d /etc/apt/keyrings

# Add Docker GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF


# =========================================================
# 3. Install Java 21 + Jenkins repository
# =========================================================

echo "===== [3/6] Installing Java 21 ====="

sudo apt-get install -y openjdk-21-jre

java -version

echo "===== Adding Jenkins repository ====="

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null


# =========================================================
# 4. Add Trivy repository
# =========================================================

echo "===== [4/6] Adding Trivy repository ====="

wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key \
  | gpg --dearmor \
  | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" \
  | sudo tee /etc/apt/sources.list.d/trivy.list > /dev/null


# =========================================================
# 5. Update repositories & install packages
# =========================================================

echo "===== [5/6] Updating repositories ====="

sudo apt-get update

echo "===== Installing Docker ====="

sudo apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

echo "===== Installing Jenkins ====="

sudo apt-get install -y jenkins

echo "===== Installing Trivy ====="

sudo apt-get install -y trivy


# =========================================================
# 6. Enable and start services
# =========================================================

echo "===== [6/6] Starting services ====="

sudo systemctl enable --now docker
sudo systemctl enable --now jenkins


# =========================================================
# Verify installation
# =========================================================

echo ""
echo "======================================"
echo " Installation completed"
echo "======================================"

echo ""
echo "----- Java -----"
java -version

echo ""
echo "----- Docker -----"
docker --version

echo ""
echo "----- Docker Compose -----"
docker compose version

echo ""
echo "----- Jenkins -----"
sudo systemctl --no-pager status jenkins || true

echo ""
echo "----- Trivy -----"
trivy --version


# =========================================================
# Jenkins Access Information
# =========================================================

echo ""
echo "======================================"
echo " Jenkins Access"
echo "======================================"

PUBLIC_IP=$(curl -s https://checkip.amazonaws.com || true)

echo ""
echo "Jenkins URL:"
echo "http://${PUBLIC_IP}:8080"

echo ""
echo "Initial Jenkins Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo ""
echo "======================================"
echo " Setup Finished!"
echo "======================================"