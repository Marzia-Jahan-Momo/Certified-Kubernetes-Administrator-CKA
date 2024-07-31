# This install-containerd.sh file have to run both worker and controle plane nodes.

#!/bin/bash

# Install and configure prerequisites
## load the necessary modules for Containerd
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Install containerd
sudo apt-get update
sudo wget https://github.com/containerd/containerd/releases/download/v1.7.11/containerd-1.7.11-linux-amd64.tar.gz  
sudo tar -C /usr/local -xzvf containerd-1.7.11-linux-amd64.tar.gz # without wget: sudo apt-get -y install containerd

# Configure containerd with defaults and restart with this config
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

# Containerd reastart, enable and status
sudo systemctl restart containerd
sudo systemctl daemon-reload 
sudo systemctl enable --now containerd
service containerd status
