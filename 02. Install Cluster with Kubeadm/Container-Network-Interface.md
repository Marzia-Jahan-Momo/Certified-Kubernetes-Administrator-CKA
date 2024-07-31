## Before networking we need to know pod fundamentals
- Pod is an abstraction over container 
- It is a smallest unit of k8s
- Every pod has a unique IP address.
- IP Address reachable from all other pod in the k9s cluster.
- Usually with one main container.
- When pod is running in a node it gets its own **Network namespace** with Virtual Ethernet Connection to connect it to the underlaying infrastructure network. 
- So pod is a host just like laptop it has ip address and range of ports to allocate. Thats why no worry of port mapping in the server where pod is running.
- Same port of diiferent pods will be no conflict cause they are isolated smallest machines.
- If you replace container runtime to any other runtime, you can do it very easily, k8s configuration would stay the same because all are in the pod level.

### Networking of withing pods
- Multiple containers in a pod called **side-car container** that is helper or side application to your main application. It is use for synchronising many db pod, back up container, schedular or authentication gateway etc.

#### How do containers communicate inside the pod?
- Pods are isolated virtual host with its own network namespace.
- Containers can talk via localhost and port

**Pause Container**: 
- Also called **sandbox** container, can use in each pod. 
- Reserves and holds network namespace (netns). Enable communication between containers. 
- If containers dies, new one is created. Pod will stay and keep its ip address. 
- If the pod itself dies, it will recreated and pod will assign a new ip address. 


### Inter pod communication (Pod to Pod communication)
- Kubernetes has no built-in solution for this inter pod communication.
- We need to implement a networking solution for this.
- But imposes fundamental requirements on any implementation to be pluggable into kubernetes there has some set of rules, This rule is called CNI or Container Networking Interface.  

#### K8s requirements for CNI Plugins
- Every pod gets its own unique ip address accross the whole cluster not just the node where pod is running. 
- Pods on same node can communicate with that IP address.
- Pods on different node can communicate with that IP address without NAT (Network Address Translation)
- Kubernetes expects a network plugin to implement a pod network for the whole cluster on the all nodes talk to each other if they are in actual same network.
- Kubernetes doesn't care about the exact IP addresses will get.

#### Network Plugins
- Many networking solutions, which implement this module.
- Ex: Flannel, Weaveworks, Cilium, VMware NSX

### How CNI Plugins implement it?

#### Inter pod communication (Pod to Pod communication) 
- Each node gets an IP address from IP range of our VPC belongs to the same private network or LAN, this is our vpc.
- As pods are isolated with own private network, on each node a private network with a different ip range is created but keep in mind this ip address range should not overlap with ip address of the nodes.
- In this private network has a private switch or bridge on the host which enables pod communication on the same node.
- Network Plugin will set the cidr block for whole cluster and make sure each node gets a different ip address or unique ip address. Thats why each node gets an equal subset of this IP range.
- Suppose "my-app" pod on Node1 wants to talk to "DB" pod on Node3, but they cannot talk directly, because of private isolated netwroks. So they have to communicate through **Gateways**
- Route rules will define in the route tables of the servers that will map each nodes ip address as a gateway to the pod network on that specific node. Gateway is basically an IP address of the node and that maps to the virtual private network cidr block that was created for the pods on that specific node. That means now "my-app" pod sends request to "db" pod route rule will be used to determine which gateway should be used to access "db" pods network since "db" pod network is on node3 the ip address of node3 or gateway will be used to access the "db" pod.
- Thats how network plugin creates 1 large pod network accross all the nodes in the cluster. We have only 3 nodes and therefore the route table was very short and manageable.   
- But how to manage thousands of nodes? Manage all those and keep in tracking wil be very difficult. So we need more automated and more scalable solution for that. A **Network Plugin** is solve this issue.
- A CNI (ex: Weave) is deployed in each node on the cluster as a pod. This pod will find each other and form a group. A weave network consists of **peers** - weave net routers reside on the nodes. They can directly talk to each other and quickly share information about which pod is running in which node.


## Manifest of Weave:
- Weave net is easy to deploy and agents run as DaemonSet.
 
#### download and install the manifest
   ```
   wget "https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml"
   ``` 
   
   ```
   kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml -O weave.yaml
   ```
    
## To change the default cidr block
   vim weave.yaml

   * Now go to DaemonSet component or kind
   * There would be containers, command -/home/weave/launch.sh below the command add:
   - --ipalloc-range=100.32.0.0/12        ## Weavenet default cidr range is 10.32.0.0/12
   * Now apply
   kubect apply -f weave.yaml

   kubectl get node  ## Now master node is in ready state.

   kubectl get pod -n kube-system   ## Now coredns pod is also in running state & another 
                                       pod is running named weave-net that manages pod 
                                       network in our cluster. 

    * To check pod network is working or not
    kubectl describe pod coredns-<suffix> -n kube-system  ## here you can see the IP address of our own cidr range

    * all pod ip address widely checking pods in output mode
    kubectl get pod -n kube-system -o wide

    * Control static pod has the node internal ip and after using the cni got the cni cidr range ip.
    kubectl get node -o wide


#### check weave net status
    kubectl exec -n kube-system weave-net-1jkl6 -c weave -- /home/weave/weave --local status

#### Now connect master node with the worker nodes
- A bidirectional trust need to be established
- Discovery (Node trust the k8s control plane)
- TLS bootstrap (K8s Control Plane trust node)

#### on master
    kubeadm --help 
    kubeadm token --help
    kubeadm token create --help
    kubeadm token create --print-join-command

#### copy the output command and execute on worker node as ROOT
    sudo kubeadm join 172.31.43.99:6443 --token 9bds1l.3g9ypte9gf69b5ft --discovery-token-ca-cert-hash sha256:xxxx

#### Kubeadm join phases:
- **Preflight:** Run join pre-flight checks.
- **Kubelet-start:** Write kubelet settings, certificates and restart the kubelet.

## afer joining workernodes with control plane on master:
    kubectl get pod -A -o wide    ## here you can see kube proxy and weave net is running on workers


## weave status
    kubectl get pod -n kube-system -o wide | grep weave
    kubectl logs weave-net-itjad -c weave           ## log in not belongs to pod rather than belongs to a container. Here you will see so many errors, to solve errors we need to adjust weave port numbers.  # Change name of the weave pod use your weave pod name


## open weave net port both control plane & worker nodes
    port: 6783  # within same vpc, not all network.
    port: 6784

    * Now again check logs
    kubectl logs weave-net-hxvcj -c weave | tail -n 20   ## You can see connection added (new peer)

    kubectl exec -n kube-system weave-net-itjad -c weave -- /home/weave/weave --local status


#### start a test pod
    kubectl run test --image=nginx
	kubectl run test2 --image=nginx
	kubectl get pod -w       ## Here w is watch 
	kubectl get pod -o wide  ## Here you can see, Ip range is allocated as we gave the weavenet cidr range


# Optional

### If you want to use Cilium or Calcio


#### Install CLI 

    CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
    CLI_ARCH=amd64
    if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
    curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
    sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
    sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
    rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
    
#### Install the plugin 
    cilium install 
    [Link to the Cilium installation guide](https://docs.cilium.io/en/latest/gettingstarted/k8s-install-default/) 

#### check cilium status
    cilium status
    kubectl -n kube-system exec cilium-2hq5z -- cilium-dbg status
    cilium connectivity test


### Install pod network plugin

#### Manifest of Calico:
    wget https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
    
    vim calico.yaml -- 
    Change CIDR to actual:
    --pod-network-cidr=10.0.0.0/16 ## that was given on kubeadm init
    CALICO_IPV4POOL_CIDR
    