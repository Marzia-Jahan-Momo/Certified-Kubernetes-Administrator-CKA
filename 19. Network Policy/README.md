#### Control Traffic - Network Policies
- By default: all communication (to and from pods) is allowed.
- With Network Policies you can control traffic flow at the IP address and port level.
- Network Policies basically defines who can talk to whom in the cluster by settings specific communication rules for the application.
- The rules are defined with NetworkPolicy resource in a k8s manifest.
- It configures the CNI application, in our case it was *weavenet*
- The Network plugin implemets the Network policies.
- **Note:** Not all Network Plugins support Network Policies. Ex: Flannel

#### How to configure Network Policies
1. Which application for which pod replicas do this policies apply - Defines in **podSelector**, if podSelector empty, then applies to all pods in defined namespace.
2. Which rule type - Defines in **policyTypes**, Incoming rules = **Ingress**, Outgoing rules = **Egress**


```
kubectl apply -f demo-* ..yaml

kubectl get pod -o wide

kubeclt exec demo-backend-<full-path> --sh -c 'nc -v <demo-database-ip> <port>'

Every pod can access to each other.
```

#### Create network policy to limit traffic in your cluster.
```
kubectl apply -f demo-np-*..yaml 

kubeclt exec demo-backend-<full-path> --sh -c 'nc -v <database-ip> <port>'

Only allowed which were specified.
```
