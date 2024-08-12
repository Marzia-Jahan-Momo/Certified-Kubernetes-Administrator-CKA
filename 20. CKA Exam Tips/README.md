### Exam Tips

#### Imperative kubectl commands
- Quickly create resources using impereative commands which do not have complex configurations, like serviceaccount, role, rolebinding etc.
- Faster compared to preparing config files.
- Also check ```commands.md``` file.
- Get used to using **--help option**
- Generate boilerplate manifests. Ex:
```
kubectl create service clusterip myservice --tcp=80:80 --dry-run=client -o yaml > myservice.yaml
```
- Use shortcuts for frequently used commands and options, ex:
```
alias k=kubectl             ----- Create an alias of kubectl

export do="--dry-run=client -o yaml"

kubectl create service clusterip myservice --tcp=80:80 $do > myservice.yaml         ------ save commands in variable
```

#### Temp file when editing Deployments
- You cannot edit all specifications of existing pods.
- You cannot add/remove containers.
- You cannot add volumes.
- You need to delete your Deployment and re-apply updated Deployment manifest.
- In the even an error occurs while updating, a temporary file will be created
```
kubectl edit deployment <deployment-name>

kubectl apply -f /tmp/file.yaml
```

### Practice these commands before exam
- Scale Deployments up and down.
```
kubectl scale --replicas=3 deployment/mysql
```
- Filter resources or components. Ex: Display all nodes, which don't have taints "NoSchedule" or, Display all "ready" nodes or, Display all Pods that have Resource Requests set or, List all pods running on worker1.
- Display resource usage Pods or Nodes.

```
kubectl top pod --help
kubectl top pod POD_NAME --containers
```
- Switching default namespace.
```
kubectl config set-context --current --namespace=<namespace-name>
```


#### Working with Root User
- You are NOT working with root user. Always you need to specify sudo, ex: sudo apt install
- Switch to root user, if you have more to do with ```sudo -i```, if not needed get back to regular users.

#### Sessions and Users
- Be careful of session switches.
- Pay attention which server and which user you are in and where you are going to switch. 
- Pay attention to the environment you are in, which kubeconfig file and which current-context you are using when you have multiple clusters.


- In exam you can use Kubernetes official Documentation, nothing else.
- So learn how to work with the docs, and use as the only source.

#### Install k8s cluster
- You won't have to install a cluster from a scratch.
- Knowinng how to do it, gives you a huge advantage.