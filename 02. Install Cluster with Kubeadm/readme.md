## Provision Infrastructure 

#### First download .pem file from cloud and move private key to .ssh folder and restrict access
    mv ~/Downloads/k8s-node.pem ~/.ssh
    chmod 400 ~/.ssh/k8s-node.pem

#### ssh into ec2 instance with its public ip
    ssh -i ~/.ssh/k8s-node.pem ubuntu@35.180.130.108

#### Configure Infrastructure
    sudo swapoff -a

#### Disable swap by opening the fstab file for editing 
    sudo vim /etc/fstab     # Comment out "/swap.img"

#### set host names of nodes
    sudo vim /etc/hosts

#### get priavate ips of each node and add this to each server 
    54.42.24.274 master
    44.52.35.345 worker1
    45.14.43.152 worker2 

    or,
    printf "\n192.168.15.93 k8s-control\n192.168.15.94 k8s-2\n\n" >> /etc/hosts
    printf "\n192.168.17.138 master\n\n" >> /etc/hosts
    printf "\n192.168.17.128 worker\n\n" >> /etc/hosts

    

#### we can now use these names instead of typing the IPs, when nodes talk to each other. After that, assign a hostname to each of these servers.

#### on master server
    sudo hostnamectl set-hostname master  # For seeing the effect, exit and reconnect. 

#### on worker1 server
    sudo hostnamectl set-hostname worker1 

#### on worker2 server
    sudo hostnamectl set-hostname worker2

#### Provision Infrastructure configured and prerequisites also done, now the time is to install application necessary to setup a cluster.
- First one is Container Runtime application.  

 -> Container Runtime is a separate application, not a kubernetes component.

 -> Kubernetes uses the container runtime to schedule the containers.

 -> All container runtime interface - container.d commands are in ```install-containerd.sh``` file.

#### After created ```install-containerd.sh``` file: 
```
chmod +x install-containerd.sh

./install-containerd.sh
```


### If any problem occur then modify Ip table forwarding:
```
# Modify "sysctl.conf" to allow Linux Node’s iptables to correctly see bridged traffic

sudo vim /etc/sysctl.conf       ### Add this line: net.bridge.bridge-nf-call-iptables = 1

# Allow packets arriving at the node's network interface to be forwaded to pods. 
sudo echo '1' > /proc/sys/net/ipv4/ip_forward
exit

- sudo vim /etc/containerd/config.toml
	#disabled_plugins = ["cri"]
	[plugins."io.containerd.grpc.v1.cri"]
	  sandbox_image = "registry.k8s.io/pause:3.9"

# Reload the configurations with the command:
sudo sysctl --system

# Load overlay and netfilter modules 
sudo modprobe overlay
sudo modprobe br_netfilter

service containerd status
```

## check swap ipconfig, ensure swap is 0
    free -m

## Now check ```port-enable.sh``` file
- First enable ports both in control plane and worker nodes.


## Check ```install-k8s-components.sh``` file
- Install kubelet, kubeadm and Kubectl

### Now Initialize a control plane node

```
sudo kubeadm init
or,
sudo kubeadm init --pod-network-cidr=10.0.0.0/16

```
**Kubeadm does**: 
- Generates /etc/kubernetes folder.
- Generates a self-signed CA to set up identities for each component.
- Put generated certificates inside.
- Generates static pod manifest files into /etc/kubernetes/manifests
- Makes all necessary configurations like pki, kubelet, etcd and so on.
- After generating static pod manifest file, kubelet will detect manifest files and start   the Pods with suffix of hostname. ex: kube-apiserver-master, etcd-master and so on.
- Kubelet will ask to containerd runtime to fetch the all the images for the application in those manifest and eventually schedule them as containers.
- Kubeadm does not install or manage kubelet thats why we have to install kubelets ourselves to starts pods and containers.

**Kubeadm init phases:**
- Preflght: Checks to validate the system state before making changes. 
- Certs: Generates a self-sighned CA to set up identities for each component in the cluster.
- Kubeconfig: Writes kubeconfig files in /etc/kubernetes/ for kubelet, controller-manager and scheduler to use to connect to the API server as well as kubeconfig file for administration.
- Kubelet-start: Writes kubelet settings and restart the kubelet.
- Control-plane: Generates static pod manifest for the API Server, Controlle-manager and Scheduler into /etc/kubernetes/manifest directory. 
- Addons: Installs a DNS Server (CoreDNS) and the kube-proxy addon components via the API server.
- Kubelet file location: /var/lib/kubelet/ and certificates: /var/lib/kubelet/pki 

#### Kubelet, Kubeadm & Kubectl in short:
- **Kubelet**: Does things like starting pods and containers, component that runs on all the machines in your cluster.
- **Kubeadm**: Command Line Tool to initialize the cluster.
- **Kubectl**: Command Line Tool to talk to the cluster. 
- All these 3 tools or application maintained by kubernetes and have to same release version.

### To install Kubelet, Kubeadm & Kubectl
- Check ```install-k8s-components.sh``` file

### Check kubelet process running 
    service kubelet status
    systemctl status kubelet
    
    ## Also check:
	cat /etc/kubernetes
	sudo kubectl get node --kubeconfig /etc/kubernetes/admin.conf

    ### Now you can see:
    kubeadm --help 

### Check extended logs of kubelet service
    journalctl -u kubelet

### 


### Access cluster as admin
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config


### Kubeconfig & Kubectl: Connect to cluster
#### How do we access the cluster once configured?
- API Server is the entrypoint to the cluster.
- Kubeadm generated client certificate that we can use
- Kubeconfig file that stores the API server address and client certificates.
- So kubeconfig file is used to connect to cluster.
- Use CLI Tool: kubectl to issue commands. 
**Kubectl**: Commands to connect to cluster.

**Kubeconfig**: Authenticate with cluster.



#### Kubeconfig file contents 
    sudo /etc/kubernetes/admin.conf


#### get node information with Kubectl commands
    sudo kubectl get node --kubeconfig /etc/kubernetes/admin.conf         ### File passed with "--Kubeconfig" flag

    - To avoid using --kubeconfig and file location, Kubectl Precedence of kubeconfig file used:
      * KUBECONFIG environment variable.
        sudo -i
        export KUBECONFIG=/etc/kubernetes/admin.conf
        
        kubectl get node        ### Worked only current session.


      * File located in "$HOME/.kube/config" folder
        mkdir -p ~/.kube          ### If ls ~/.kube   not found
        sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config 
        -- Now this folder is for root user to change it into current user:
        echo $(id -u)
        echo $(id -u)
        sudo chown $(id -u):$(id -u) ~/.kube/config
        ls -l ~/.kube/config

        kubectl get node        ### Worked in every session.


### Namespace
- Virtual cluster inside a cluster.
- Organise resources in Namespaces.
- Resources grouped in Namespaces.
- Can access service in another Namespace.
- There has some components which cannot be created within a Namespace they are globally in Cluster, cannot isolate them in Namespaces.
- Better to create a Namespace with a configuration file.

```
## To see the existing namespaces
   kubectl get ns
```
- There has 4 namespaces present when the cluster got initiated:
    1. default: This is used as a default when executing kubectl commands. 
    2. kube-system: Control plane pods are located in kube system namespace.
    3. kube-public
    4. kube-node-lease

```
## get pods in default namespace
   kubectl get pod

## get pods in kube-system namespace
   kubectl get pod -n kube-system

## get pods from all namespaces
   kubectl get pod -A

## get wide output
   kubectl get pod -n kube-system -o wide

## If you want to not bound any resources to namespace
   kubectl api-resources --namespaced=false
```

### Install pod network plugin
- Check ``` Container-Network-Interface.md ``` file
  


### Join worker nodes

#### on master
    kubeadm token create --help
    kubeadm token create --print-join-command

#### copy the output command and execute on worker node as ROOT
    sudo kubeadm join 172.31.43.99:6443 --token 9bds1l.3g9ypte9gf69b5ft --discovery-token-ca-cert-hash sha256:xxxx

#### start a test pod
    kubectl run test --image=nginx


