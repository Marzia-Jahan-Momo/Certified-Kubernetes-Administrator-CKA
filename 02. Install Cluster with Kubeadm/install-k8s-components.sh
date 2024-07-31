# Install packages needed to use the Kubernetes apt repository
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# Download the Google Cloud public signing key
# If the directory `/etc/apt/keyrings` does not exist, it should be created before the curl command.
# sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add the Kubernetes apt repository
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install kubelet, kubeadm & kubectl, and pin their versions
sudo apt-get update

# check available kubeadm versions (when manually executing)
apt-cache madison kubeadm

# Install latest or specific version 1.28.0 for all components
sudo apt-get install -y kubelet kubeadm kubectl
or,
sudo apt-get install -y kubelet=1.28.0-1.1 kubeadm=1.28.0-1.1 kubectl=1.28.0-1.1

## apt-mark hold prevents package from being automatically upgraded or removed
sudo apt-mark hold kubelet kubeadm kubectl

## Checking those installed or not:
kubeadm --help
kubeadm version
kubectl version


