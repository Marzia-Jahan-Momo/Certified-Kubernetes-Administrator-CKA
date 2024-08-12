#### Upgrading the k8s cluster with minimum app downtime.
- Updgrade works in both control plan & worker nodes.

##### On Master Node 
- When upgrading the master node they will be inaccessible. Though master node is inaccessible, worker nodes works perfectly thats why there will no application downtime. 
- But management functionalities are not available because API server is down.
- Crashed pods won't be rescheduled.
- If you want to live master node while upgrading you need more than 1 control plane node.
- Upgrade each control plane one by one.
- Recommended: Upgrade control plane's all components at same versions.

##### How to upgrade these control plane components?
- The way you upgrade the cluster depends on how you initially deployed it.
- As we use kubeadm init, we will follow this.
- Upgrade kubeadm tool.
- With kubeadm, upgrade all control plane components and renew cluster certificates.
- Only kubelet and kubectl was not installed through kubeadm so, we will use drain nodes to remove all pods that will evict all pods safely using ```kubectl drain master``` & will be marked as unschedulable. Now we can upgrade kubelet & kubectl. Finally change master back to schedulable using ```kubectl uncordon master```.


##### On Worker Nodes
- Upgrade kubeadm
- Execute kubeadm to upgrade all kubelet configuration.
- Drain the node, pods will be rescheduled on other Nodes will be marked as unschedulable and upgrade kubelet.
- Change worker node back to schedulable.
- Upgrade worker node with above steps one by one.
- For no application downtime you need at least 2 worker ndoe and at least 2 pod replicas.


##### Draining and Cordon
- Draining means marked nodes unschedulable and will evict all pods and scheduled somewhere else.
- Cordon means only marked nodes unschedulable but do not evict all pods, existing pods will stay on Node. and Uncordon commands marks node schedulable


##### When and how often should you upgrade k8s cluster
- Use case: Fix in later k8s version, which affects your cluster.
- You should always keep your cluster up to date with new versions.
- RecommendedL upgrade 1 version at a time ex: v1.18 to v1.19, do not jump v1.18 to v.21 