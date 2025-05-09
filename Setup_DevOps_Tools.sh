#!/bin/bash

set -e

echo "🔧 Updating system..."
sudo apt update -y
sudo apt upgrade -y

echo "📦 Installing Git..."
sudo apt install -y git

echo "☕ Installing OpenJDK 17..."
# Remove Java 21 if present
sudo apt remove --purge -y openjdk-21-* || true
# Install Java 17
sudo apt install -y openjdk-17-jdk

echo "🔐 Adding Jenkins repo key..."
sudo mkdir -p /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "📄 Adding Jenkins repo to sources..."
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "🔄 Updating package index..."
sudo apt update -y

echo "📥 Installing Jenkins..."
sudo apt install -y jenkins

echo "✅ Ensuring Jenkins service directory exists..."
sudo mkdir -p /var/lib/jenkins
sudo chown -R jenkins:jenkins /var/lib/jenkins

echo "🚀 Starting and enabling Jenkins..."
sudo systemctl daemon-reexec
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "🐳 Installing Docker..."
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

echo "☸️ Installing MicroK8s..."
sudo snap install microk8s --classic
# Add user to microk8s group
sudo usermod -a -G microk8s $USER
# Fix permissions
sudo chown -f -R $USER ~/.kube
sudo newgrp microk8s
