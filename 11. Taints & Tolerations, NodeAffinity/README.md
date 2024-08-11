- Pods are automatically scheduled on one of the worker nodes.
- Schedular decides intelligently, where to place the pod.

### NodeName
- In some cases, we may want to decide ourselves where the pod get scheduled. It can be done with **nodeName**. It is the simplest form of selecting a Node.

### NodeSelector
- If nodename is cluster are dynamic. So you don't know the names beforehand, this is very common in cloud environments. Then we will use **node-selector** attribute using **labels**, this is also use when there has not enough resources to run the pod, in that case pod will not scheduled in anywhere. NodeSelector has more flexibility over nodeName
**1.** Attach label to the node. 
**2.** Add nodeSelector field to pod configuration  

### NodeAffinity
- Schedule pods on specific nodes for different purpose uses nodeAffinity.
- Similar to nodeSelector, but affinity language is more expressive.
- Match labels more flexible with logical operators (In, Not In, Exists, DoesNotExist, Gt, Lt).
- But its syntax is more complex.
- You can define multiple rules in the yaml file under the affinity section.
- Ex: 2 types of node affinity: 
1. Soft = preferred, tried to match its expression, Specified rules are preferences, if not find that schedule in something else, schedule will try to enforce.  
2. Hard = required, required rules must be met with the node, Similar to nodeSelector


### Taint
- Taint is enabled in master node by kubeadm when k8s cluster was initiated or bootstrapping thats why no pod can schedule in master node. Just like pods repels certain nodes, nodes can also repel certain pods.
- Taint applied to Nodes
```
kubectl describe node master
```
```
kubectl describe node | grep Taint
``` 

### Toleration
- Toleration applied to pods.
- Allow the pods to schedule onto Nodes with matching taints.
- In master node pods you can find Tolerations is NoExecute.
- So, Taints and Tolerations work together.
```
kubectl describe pod -n kube-system etcd-master
```
```
kubectl get pod -n kube-system -o custom-columns=POD_NAME:.metadata.name,TOLERATIONS:.spec.tolerations
```

- To configure toleration for master taint check ```pod-with-tolerations.yaml``` file. But this does not gurantee that pod is scheduled on control plane. Pod tolerates now all pods, scheduler selects between all nodes. To gurantee that its scheduled there with node selector, node name, node affinity.

### Inter-Pod Anti-Affinity rule
- Allows you to constrain, which nodes your pod is eligible to be scheduled, based on labels on pods that are already running on the node. In other word, This pod should not run on worker1 if worker2 is already running one or more pods with a specific label.
- Inter-pod affinity works under pod labels whereas node affinity works under node labels.
- Inter-pod affinity is pritty similar as DaemonSet does. DaemonSet schedules 1 replica on each worker node.

#### Do not overuse these scheduling constraints of Inter-pod affinity, Node Selector, Node affinity, Node Name, Taints & Tolerations. We interfere as liitle as possible with k8s scheduling features.