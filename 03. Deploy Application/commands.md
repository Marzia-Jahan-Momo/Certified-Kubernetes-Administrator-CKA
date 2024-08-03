### Kubectl commands

#### apply manifests
    kubectl apply -f nginx-deployment.yaml
    kubectl apply -f nginx-service.yaml

#### labels
    kubectl get svc
    kubectl describe svc {svc-name}
    kubectl get ep  ## Here ep means Endpoints

    kubectl get svc --show-labels
    kubectl get svc -l app=nginx 

##### Service is not a process running on the Nodes. Its a virtual IP address accessible throughout the cluster. 
##### Request > Service > Kube-proxy > Pod
##### Kube proxy forwards the request. Responsible for maintaing list of Services IPs and corresponding Pod IPs.

    kubectl get pod --show-labels
    kubectl get pod -l app=nginx
    kubectl logs -l app=nginx

    kubectl get pod -n kube-system --show-labels
    kubectl logs -n kube-system -l="name=weave-net" -c weave

    kubectl get node —show-labels

    kubectl get all

    kubectl edit svc {svc-name}                 # or,
    kubectl get svc {svc-name} -o yaml

    ktl edit deployment nginx-deployment        # or,
    ktl get deployment nginx-deployment -o yaml



#### scaling deployments
    kubectl scale --help
    kubectl scale deployment {depl-name} --replicas 4
    kubectl scale deployment {depl-name} --replicas 3

    kubectl scale deployment {depl-name} --replicas 5 --record   # Record is important to track, not only scale, record can be done to create, apply etc - But its been deprecated.

    kubectl rollout history deployment {depl-name}


#### create pods to temporarily test accessing previous pods with curl, Thats why no need for a deployment file. Test and remove it.
    kubectl run test-nginx-service --image=busybox
    kubectl exec -it {pod-name} -- bash

    curl http://10.109.170.40:8080   # Service ip
    curl nginx-service:8080          # SErvice name
##### Sometime curl with service name will not work it is because of DNS  

#### K8s Master and Worker processes use labels to target other components in the cluster.
    ktl get pod -n kube-system --show-labels

    ktl get node --show-labels

##### Labels to identify and target any k8s component. Its optional but best practices. 
##### Each object in the cluster has a name that is unique for that type of resource.
##### Not allowed: 2 services with same name within the same namespace.


##### Every service has its own dns in /etc/hosts file, but to track thousands of servcies dns in each /etc/hosts file is cumbersome. So k8s chose in a centralized place point the pods to the nameserver. This place is /etc/resolv.conf. 
    kubectl exec -it {pod-name} -- bash

    cat /etc/resolv.conf  # nameserver has ip of kube-dns

    kubectl get svc -n kube-system | grep dns

#### Who tell nameserver in the /etc/resolv.conf talk to the kube-dns ip?
- Its Kubelet, kubelet automatically creates /etc/resolv.conf file for each pod
- ``` sudo cat /var/lib/kubelet/config.yaml ``` there you will find clusterDNS

#### - Nameserver in the k8s cluster. - Manages list of service names and their IP Addresses. - All pods point to this nameserver. **DNS server in k8s is CoreDNS/kubeDNS**. In the very first- kubeadm init command this CoreDNS was installed with addons. You can find it in ``` kubectl get pod -n kube-system ```
##### So for troubleshooting of DNS problem check logs of Coredns/kube-dns


#### Checking same service in another namespace and deployments is in different namespace, can they talk?
``` kubectl create ns test-ns
```

```
kubectl run test-nginx-svc -n test-ns --image=nginx      ## Same service name but different namespace. 

```
    kubectl get svc

    curl 10.109.170.40:8080   ## ip of the service can talk

    curl {service-name}:8080  ## svc name cannot talk.  # This is because every namespace coredns creates subdomain. 
    
##### Fully qualified domain name of any service (FQDN):
    <servicename>.<namespace>.svc.cluster.local  
- No need to tell .svc.cluster.local -> Because of the search entry in ```cat /etc/resolv.conf``` which is a list for host-name lookup. 

##### Kubernetes searches only in the same namespace, so for troubleshoot dns, explicitly tell the namespace name:
    curl {service-name}.default:8080 # as deployment file was in default ns, svc should be also in default ns 

- **Same Namespce:** Only name is sufficient
- **Different Namespace:** You need to include that namespace 
  

#### Where does clusterIP came from?
- ``` kubectl get svc ``` in type it has ClusterIP
- Default service type is ClusterIP
- Expose the Service on a cluster-internal IP
- Service only reachable from within the cluster
- IP Address range is defined in Kube API Server Configuration, it is defined in ``` sudo cat /etc/kubernetes/manifests/kube-apiserver.yaml ``` you can find the parameter of ``` --service-cluster-ip-range=10.96.0.0/12 ``` A cidr notation ip range from which to assign service custer IPs (internal ip address)
- This range 10.96.0.0/12 is came from ``` kubeadm init --help ``` You can find ``` --service-cidr string ``` default ip range. or you can also check ``` kubeadm config print init-defaults ```
- To change the default CIDR notation you need to change in static pod manifest files ``` sudo vim /etc/kubernetes/manifests/kube-apiserver.yaml ``` -> here kubelet periodically scans the configurations for changes and reload all the pods. Change it to ``` --service-cluster-ip-range=20.96.0.0/12 ``` - It needs few times to restart the kubelet.
- New CIDR block only applies for newly created services to check the effect:
- ``` kubectl create svc clusterip test-new-cidr --tcp=80:80 ``` now check ``` kubectl get svc ```