### Pod
```sh
kubectl run my-pod --image=nginx --dry-run=client -o yaml > my-pod.yaml
```

### Deployment
```sh
kubectl create deployment my-deployment --image=nginx --dry-run=client -o yaml > my-deployment.yaml
```

### Service
```sh
kubectl expose deployment my-deployment --port=80 --target-port=80 --name=my-service --dry-run=client -o yaml > my-service.yaml
```

### ConfigMap
```sh
kubectl create configmap my-config --from-literal=key1=value1 --dry-run=client -o yaml > my-configmap.yaml
```

### Secret
```sh
kubectl create secret generic my-secret --from-literal=password=my-password --dry-run=client -o yaml > my-secret.yaml
```


### Ingress
```sh
kubectl create ingress my-ingress --rule="my.host/path=service:80" --dry-run=client -o yaml > my-ingress.yaml
```

### Namespace
```sh
kubectl create namespace my-namespace --dry-run=client -o yaml > my-namespace.yaml
```

### ServiceAccount
```sh
kubectl create serviceaccount my-serviceaccount --dry-run=client -o yaml > my-serviceaccount.yaml
```

### Role
```sh
kubectl create role my-role --verb=get --verb=list --verb=watch --resource=pods --dry-run=client -o yaml > my-role.yaml
```

### RoleBinding
```sh
kubectl create rolebinding my-rolebinding --role=my-role --serviceaccount=default:my-serviceaccount --dry-run=client -o yaml > 
my-rolebinding.yaml
```

### ClusterRole
```sh
kubectl create clusterrole my-clusterrole --verb=get --verb=list --verb=watch --resource=pods --dry-run=client -o yaml > 
my-clusterrole.yaml
```

### ClusterRoleBinding
```sh
kubectl create clusterrolebinding my-clusterrolebinding --clusterrole=my-clusterrole --serviceaccount=default:my-serviceaccount 
--dry-run=client -o yaml > my-clusterrolebinding.yaml
```

### CronJob
```sh
kubectl create cronjob my-cronjob --image=busybox --schedule="*/5 * * * *" -- /bin/sh -c "date" --dry-run=client -o yaml > 
my-cronjob.yaml
```

### Job
```sh
kubectl create job my-job --image=busybox -- /bin/sh -c "date; sleep 30" --dry-run=client -o yaml > my-job.yaml
```

### PodDisruptionBudget
```sh
kubectl create pdb my-pdb --min-available=1 --selector=app=my-app --dry-run=client -o yaml > my-pdb.yaml
```

### PriorityClass
```sh
kubectl create priorityclass my-priority --value=1000 --global-default=false --description="My priority class" --dry-run=client 
-o yaml > my-priorityclass.yaml
```

### ResourceQuota
```sh
kubectl create quota my-quota --hard=pods=10,cpu=20,memory=50Gi --dry-run=client -o yaml > my-quota.yaml
```

### ServiceAccount Token

**Create the ServiceAccount manifest:**
```sh
kubectl create serviceaccount my-serviceaccount --dry-run=client -o yaml > my-serviceaccount.yaml
```

**Create a Secret for the token:**
```sh
    kubectl create secret generic my-token --from-literal=token=$(openssl rand -base64 32) --dry-run=client -o yaml > my-token.yaml
```

---
Alternatively, Kubernetes automatically creates a token for each ServiceAccount. To get the token for an existing ServiceAccount:
```sh
kubectl get secret $(kubectl get serviceaccount my-serviceaccount -o jsonpath='{.secrets[0].name}') -o yaml > 
my-serviceaccount-token.yaml
```


## **Note:** Cannot create ```PersistentVolume``` and ```PersistentVolumeClaim```

