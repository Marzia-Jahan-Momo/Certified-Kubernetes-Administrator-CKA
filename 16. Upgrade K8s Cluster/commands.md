### Upgrade control plane node

##### check apt-get version    
    sudo -i
    sudo apt-get --version
    kubeadm version
    apt-cache madison kubeadm
    

##### for apt-get version gt 1.1
    sudo apt-get update
    sudo apt-get install -y --allow-change-held-packages kubeadm=1.22.0-00    ### Check latest in the documentation
    kubeadm version

##### get upgrade preview
    sudo kubeadm upgrade plan

##### upgrade cluster 
    sudo kubeadm upgrade apply v1.22.0

##### drain node
    kubectl drain master --ignore-daemonsets

##### upgrade kubelet & kubectl 
    sudo apt-get update
    sudo apt-get install -y --allow-change-held-packages kubelet=1.22.0-00 kubectl=1.22.0-00

##### restart kubelet
    sudo systemctl daemon-reload
    sudo systemctl restart kubelet

##### uncordon node
    kubectl uncordon master

    kubectl get node


### Upgrade worker node
    sudo apt-get update && \
    sudo apt-get install -y --allow-change-held-packages kubeadm=1.22.x-00

    sudo kubeadm upgrade node

    kubectl drain worker1 --ignore-daemonsets --force

    kubectl get pod -o wide   ---- here you can see, all pods moved into worker2

    kubectl get pod -A -o wide | grep worder1 --- here, only daemonset(kube-proxy and weave-net) can running

    sudo apt-get update
    sudo apt-get install -y --allow-change-held-packages kubelet=1.22.x-00 kubectl=1.22.x-00

    sudo systemctl daemon-reload
    sudo systemctl restart kubelet

    kubectl uncordon worker1

    kubectl get node   ## nodes are upgraded
