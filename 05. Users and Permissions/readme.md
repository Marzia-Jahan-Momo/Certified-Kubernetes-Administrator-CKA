### Why we need permissions?
- Administer manage k8s cluster they have admin access. 
- For developers or other users has to very limited access to deploy to k8s cluster as if they cannot destroy the cluster accidentally.
- Manage permissions with **Least Privilege Rule**

#### How to restrict access to only their own namespace?
- For this restriction purpose k8s has RBAC(Role Based Access Control) concept.
- With RBAC you can define access to each namespace using **Roles**
- Role is bound to a specific Namespace to what resources in that namespace you can access (Ex: Pod, Deployment, Service etc) and What action you can do with this resources (List, Get, Update, Delete etc).
- Role defines resources and access permissions. But no information on who get these permissions.

#### How to attach Role definition to a person or team.
- To attach Role definition to a person with **RoleBinding**
- RoleBinding is simply Link ("Bind") a Role to a User or Group.
- All members of a Group get permissions defined in the Role.

#### For Administrators
- Administrators manages full cluster. They are managing all namespaces, configuring volumes cluster-wide etc. Basically they are doing cluster wide operations.
- For managing all these only Role is not sufficient, Role is for only limited to a namespace. But admins need to cluster wide operation. For that another component from RBAC - **ClusterRole**
- ClusterRole defines resources and persmissions cluster wide.
- Admin Group attaches to the ClusterRole with the **ClusterRoleBinding**

#### How do we create Users and Groups in k8s?
- Kubernetes doesn't manage Users natively.
- Admins can choose from different authentication strategies. 
- There has no Kubernetes Objects exist for representing normal user accounts.
- External Sources for Authentication - could be **Static Token File** (Token, User. UID), **Certificates** (That signed by k8s itself), **3rd Party Identity Service** (Ex: LDAP-Lightweight Directory Access Protocol)
- So kubernetes Administrator configures external sources Static Token File, Certificates, 3rd Party Identity Service and API Server (API Server handles authentication of all the requests, API server uses one of these configured authentication methods.)
- Pass token file via ``` --token-auth-file=/users.csv ``` command line option 
```
kube-apiserver --token-auth-file=/users.csv [other options]
```

### For certificates
- You as an admin have to manually create certificates for different users or configure LDAP as authentication source.

##### Kubernetes allows you to configure these external sources but don't manage them for you. You have to manage them yourself as a k8s administrative.

### Authorization for Applications
- Applications are **inside** the cluster and **outside** the cluser.
- Inside - Monitoring apps like Prometheus, which collects metrics from other apps within cluster, Microservice applications needing access only within their namespace.
- Outside - CI/CD Server deploying apps inside the cluster, Terraform application that configuring the cluster itself.
- We also want apps to have least privilege rule means to have only the permission it needs in the cluster not more.
- For applying those in applications - k8s component that represents an Application user that is called **ServiceAccount**
- User is not an own k8s component
- Link ServiceAccoung to user Role with **RoleBinding**
- Link ServiceAccoung to cluster Role with **ClusterRoleBinding**
```kubectl create serviceaccount sa1```


### Checking API Access or Permissions
- Kubectl provides a **auth can-i** subcommand.
- To quickly check if current user can perform a given action.
```
kubectl auth can-i create deployments --namespace dev
```
- Admins can also check permissions of other users to see what permissions in any namespace.

### Layers of security
```
CI/CD Request to create new service in ns -> 
1st level, API Serviver will check is this user allowed to permit with Authentication(you can enable multiple authentication methods at once) -> 
2nd level, Check Authorization user with authentication using RBAC, will check Role, ClusterRole and bindings.
```

### Authorization Modes
- 4 Different Authorization Modes
1. Node
2. ABAC (Attribute Based Access Control)
3. RBAC (Role Based Access Control)
4. Webhook

- You can choose more than one authorization module.
- RBAC is one of four Authorization Modes

##### Where to enable the authorization mode?
- In the API Server configuration enable the authorization mode. To check:
```sudo cat /etc/kubernetes/manifests/kube-apiserver.yaml``` there has parameter of ```--authorization-mode=Node,RBAC```
- By default it has Node and RBAC authorization mode enabled.


## Certificates
- Certificates are stored in ```/etc/kubernetes/pki``` folder
- Server Certificates - apiserver.key(private key) & apiserver.crt (public key)
- For etcd ```/etc/kubernetes/pki/etcd```

- Client certificates for services talking to API Server in ```/etc/kubernetes/kubelet.conf```

#### Who signed those Certificates?
- Kubeadm generated a CA for k8s cluster. Kubernets-ca or "Cluster root CA", etcd-ca
- All clients have a copy of k8s CA thats signed with the API Server certificates.
- K8s CA's are trusted within K8s by all components, who have a copy of the CA.

#### Configure user authentication of certificates ca
- Process of signing a Clinet Certificate:
1. Create a key-pari
2. Generate CSR (Certificate Signing Request)
3. Send CSR using k8s Certificate API
4. K8s signs certificates for you using its certificates authority or ca.
5. It will in pending state, you as a k8s administrator can make a final decision whether request should approve or denied.

### Demo Overview for generating certificate signed by k8s CA
- Create client key with openssl
- Create Certificate Signing Request (CSR) for key
- Approve CSR
- Get signed certificate from k8s.
- Finally user get access cluster with all these credencial.
- Set permissions for the user to create, delete, update k8s resources like pod, deployment, services etc.
- Validate user permissions by checking its authorization that user has and what permission he does not have.
- For creating user account check ```commands.md``` file

#### Access to cluster for non human user
- Create ServiceAccount for ci/cd tool
- Give permissions to create, delete, update k8s resources like pod, deployment, services etc.