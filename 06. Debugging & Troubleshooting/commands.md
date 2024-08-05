## Simple path of troubleshooting pod and application

### Debug pod
    kubectl get pod <pod_name>

#### Is pod registered with service? Is service forwarding the request?
    kubectl get ep
    kubectl describe <service_name>


#### Is Service accessible?
    nc <service_ip> <service_port>

#### access service ip returned by nslookup
    ping <service-ip>
    ping <service-name> 

#### Check application logs
    kubectl logs <pod_name>

#### Check pod status and recent events
    kubectl describe pod <pod_name>


## Debug with temporary pod
- Pod Network is different from Cluster Node Network. All pods are in its private virtual network.
- Execute troubleshooting commands from within a Pod. Common docker images with Unix utilities. Ex: **Busy Box image**

##### Commands and Args
- Container lives as long as process inside lives. Executes a specifix task. Container exits once task is done.
- Where do you see what process a container start? Ans: You will see at Dockerfile of that image.

#### start busybox in interactive mode
    kubectl run debug-pod --image=busybox -it 
    kubectl exec debug-pod -it -- sh  

#### Docker **entrypoint** is **command** in k8s and Docker **CMD** is **args** in k8s.

#### check service name can be resolved
    nslookup nginx-service.default.svc.cluster.local
    nslookup nginx-service

### Execute commands in pod from master node
    kubectl apply -f busybox-pod.yaml
    kubectl exec -it pod-name -- sh

##### ping service
    kubectl exec -it pod-name -- sh -c "ping nginx-service"

    kubectl exec -it pod-name --sh -c "while true; do echo hello; sleep 2; done"
##### print all envs
    kubectl exec -it pod-name -- sh -c "printenv"


##### print all running ports
    kubectl exec -it pod-name -- sh -c "netstat -lntp"


### Jsonpath output format
- Kubectl uses JSONPath expressions to filter on specific fields in the JSON object and format the output.

    kubectl get node -o json
    kubectl get pod -o json 

##### for single pod
    kubectl get pod -o jsonpath='{.items[0].metadata.name}'     # JSONPath is a query language for JSON. 

##### print for all pods
    kubectl get pod -o jsonpath='{.items[*].metadata.name}'

##### multiple attributes
    kubectl get pod -o jsonpath="{.items[*]['metadata.name', 'status.podIP']}"
    kubectl get pod -o jsonpath="{.items[*]['metadata.name', 'status.podIP', 'status.startTime']}"

##### print multiple attributes on new lines
    kubectl get pod -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'

    kubectl get pod -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.podIP}{"\n"}{end}'  # t is tab and n is new line

    kubectl get pod -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.podIP}{"\t"}{.status.startTime}{"\n"}{end}'

### Custom columns output
    kubectl get pods -o custom-columns=POD_NAME:.metadata.name,POD_IP:.status.podIP,CREATED_AT:.status.startTime


### Debugging kubelet
    service kubelet status
    
    journalctl -u kubelet

    which kubelet

    sudo vim /etc/systemd/system/kubelet.service.d/10-kubeadm.conf  # Check correct location 

    sudo systemctl daemon-reload
    sudo systemctl restart kubelet
    service kubelet status

### Debugging kubectl
    cat ~/.kube/config
    - Validate Cluster, certificate-authority-data, server
    - copy the certificate-authority-data code and decode with | base64 --decode 
    - check decoded code with:
      sudo cat /etc/kubernetes/pki/ca.crt

    - Check if server endpoint is correct?
      kubectl config view               # Check server ip and port and others. 

    kubectl cluster-info