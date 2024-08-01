#!/bin/bash

# Install packages needed to use the Kubernetes apt repository
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# Create the directory for the keyring if it doesn't exist
sudo mkdir -p /etc/apt/keyrings

# Download the Google Cloud public signing key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add the Kubernetes apt repository
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update the package list
sudo apt-get update -y

# Install kubelet, kubeadm, and kubectl
sudo apt-get install -y kubelet kubeadm kubectl

# Prevent the packages from being automatically upgraded or removed
sudo apt-mark hold kubelet kubeadm kubectl

## Checking those installed or not:
kubeadm --help
kubeadm version
kubectl version


