## Create client certificate

#### create 2048-bit RSA key
    openssl genrsa -out dev-momo.key 2048

#### create user Certificate Signing Request
    openssl req -new -key dev-momo.key -subj "/CN=momo" -out dev-momo.csr   # CN is certificate name, it is use when k8s validate the request.

#### get the base64 encoded value of the csr file
    cat dev-momo.csr | base64 | tr -d "\n"

#### create CSR in k8s in ```dev-momo-csr.yaml``` file, get csr and put it into request:

```
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: dev-momo
spec:
  request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1ZqQ0NBVDRDQVFBd0VURVBNQTBHQTFVRUF3d0dZVzVuWld4aE1JSUJJakFOQmdrcWhraUc5dzBCQVFFRgpBQU9DQVE4QU1JSUJDZ0tDQVFFQTByczhJTHRHdTYxakx2dHhWTTJSVlRWMDNHWlJTWWw0dWluVWo4RElaWjBOCnR2MUZtRVFSd3VoaUZsOFEzcWl0Qm0wMUFSMkNJVXBGd2ZzSjZ4MXF3ckJzVkhZbGlBNVhwRVpZM3ExcGswSDQKM3Z3aGJlK1o2MVNrVHF5SVBYUUwrTWM5T1Nsbm0xb0R2N0NtSkZNMUlMRVI3QTVGZnZKOEdFRjJ6dHBoaUlFMwpub1dtdHNZb3JuT2wzc2lHQ2ZGZzR4Zmd4eW8ybmlneFNVekl1bXNnVm9PM2ttT0x1RVF6cXpkakJ3TFJXbWlECklmMXBMWnoyalVnald4UkhCM1gyWnVVV1d1T09PZnpXM01LaE8ybHEvZi9DdS8wYk83c0x0MCt3U2ZMSU91TFcKcW90blZtRmxMMytqTy82WDNDKzBERHk5aUtwbXJjVDBnWGZLemE1dHJRSURBUUFCb0FBd0RRWUpLb1pJaHZjTgpBUUVMQlFBRGdnRUJBR05WdmVIOGR4ZzNvK21VeVRkbmFjVmQ1N24zSkExdnZEU1JWREkyQTZ1eXN3ZFp1L1BVCkkwZXpZWFV0RVNnSk1IRmQycVVNMjNuNVJsSXJ3R0xuUXFISUh5VStWWHhsdnZsRnpNOVpEWllSTmU3QlJvYXgKQVlEdUI5STZXT3FYbkFvczFqRmxNUG5NbFpqdU5kSGxpT1BjTU1oNndLaTZzZFhpVStHYTJ2RUVLY01jSVUyRgpvU2djUWdMYTk0aEpacGk3ZnNMdm1OQUxoT045UHdNMGM1dVJVejV4T0dGMUtCbWRSeEgvbUNOS2JKYjFRQm1HCkkwYitEUEdaTktXTU0xMzhIQXdoV0tkNjVoVHdYOWl4V3ZHMkh4TG1WQzg0L1BHT0tWQW9FNkpsYWFHdTlQVmkKdjlOSjVaZlZrcXdCd0hKbzZXdk9xVlA3SVFjZmg3d0drWm89Ci0tLS0tRU5EIENFUlRJRklDQVRFIFJFUVVFU1QtLS0tLQo=
  signerName: kubernetes.io/kube-apiserver-client
  # expirationSeconds: 8640000  # hundred day
  usages:
  - client auth
```
    kubectl apply -f dev-momo-csr.yaml

#### review CSR
    kubectl get csr

    To see the kubernets-admin requester:
    cat ~/.kube/config | grep kubernetes-admin -A2

#### approve CSR
    kubectl certificate approve dev-momo

#### get dev-momo's signed certificate
    kubectl get csr dev-momo -o yaml

#### save decoded cert to dev-momo.crt file
    from kubectl get csr dev-momo -o yaml copy the certidicate base64 code and decode with:
    echo 'base64 code' | base64 --decode > dev-tom.crt  
    
    # You can get the actual certificate # crt is public key and key is private key

#### connect to cluster as dev-momo user
    kubectl options
    kubectl cluster-info # you can get k9s control plane address that is also called api-server-address. 

    kubectl --server={api-server-address} \
    --certificate-authority=/etc/kubernetes/pki/ca.crt \
    --client-certificate=dev-momo.crt \
    --client-key=dev-momo.key \
    get pods

    ## Another approach
    cp ~/.kube/config ~/dev-momo.conf
    vim dev-momo.conf 
    - Here change users: -name: dev-momo # Instead of kubernetes-admin
    - Also changer -context user: dev-momo and name: dev-momo@kubernetes # Instead of kubernetes-admin
    - Delete -data word in client-certificate-data, keep only client-certificate: & remove whole code, reference the file, client-certificate: /home/ubuntu/dev-momo.crt
    -  Delete -data word in client-key-data, keep only client-key: & remove whole code, reference the file, client-certificate: /home/ubuntu/dev-momo.key   # Must check the file path

    kubectl --kubeconfig dev-momo.conf get pod # This allows authenticated but no permissions yet.

- Now give dev-momo.conf, dev-momo.crt, dev-momo.key this 3 files to Developer Momo as if she can execute kubectl command in her cluster. On her own laptop Momo can basically take this dev-momo.conf(kubeconfig) file and put it her own directory ~/.kube/config location   
- If you donot use 3 files, just encode dev-momo.key with ```base64 dev-momo | tr -d "\n"``` and paste it into ```dev-momo.conf``` file with adding of ```client-key-data```. Use same for ```client-certificate-data``` and finally send the dev-momo.conf file to developer Momo.

- But still now User get Authentication Permission but not get authorization permission, for that user need RBAC role with cluster role or role.

#### Create cluster role & binding
- Give permission to CRUD common resources in all namespaces.
```
kubectl create clusterrole dev-cr --verb=get,list,create,update,delete --resource=deployments.apps,pods --dry-run=client -o yaml > dev-cr.yaml

kubectl describe clusterrole dev-cr

kubectl create clusterrolebinding dev-crb --clusterrole=dev-cr --user=momo --dry-run=client -o yaml > dev-crb.yaml # roleRef = Reference existing role. subjects = Reference existing user, group or service account.

kubectl describe clusterrolebinding dev-crb

#### Checking API Access
kubectl get pod
kubectl get svc
kubectl get node
```

#### check user permissions as dev-momo
    kubectl auth can-i get pod      # auth can-i = kubectl subcommand for quickly querying the eAPI authorization layer.  

#### check user permissions as admin
    kubectl auth can-i get pod —-as {user-name}
    kubectl auth can-i get node —-as {user-name}


### Create Service Account with Permissions
    kubectl create serviceaccount cicd-sa --dry-run=client -o yaml > cicd-sa.yaml
    kubectl apply -f cicd-sa.yaml

    kubectl describe serviceacccount cicd-sa  # A token controller watches ServiceAccount Creation and creates a corresponding ServiceAccounf token secret to allow API access.

    kubectl get secret cicd-sa-token > -o yaml

    copy the token from cicd-sa-token and decode:
    echo <token> | base64 --decode      # Copy the decoded code keep it in a variable.
    token=<token>
    echo $token

    kubectl create role cicd-role

    kubectl create clusterrolebinding cicd-binding \
    --clusterrole=cicd-role \
    --serviceaccount=default:cicd

### Access with service account token

    kubectl options

    kubectl --server $server \
    --certificate-authority /etc/kubernetes/pki/ca.crt \
    --token $token \
    --user cicd-sa \
    get pods

    echo $token
    place this token into cacd-sa.conf file and set as a value under users: user: token

    - Give permission only to specific namespace. Use Role for namespaced permissions. Now Create role in Default ns and craete RoleBinding. 

    kubectl create cicd-role --verb=create,update,list --resource=deployments.apps,services --dry-run=client -o yaml > cicd-role.yaml
    kubectl apply -f cicd-role.yaml

    kubectl create rolebinding cicd-binding --role=cicd-role --serviceaccount=default:cicd-sa --dry-run=clinet -o yaml > cicd-binding.yaml 

    kubectl apply -f cicd-binding.yaml

    - Check as a admin user:
    kubectl auth can-i create service --as system:serviceaccount:default:cicd-sa -n default
    kubectl auth can-i create deployment --as system:serviceaccount:default:cicd-sa -n kube-system