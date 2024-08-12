#### How to use kubectl to switch between multiple clusters?
- With --kubeconfig file you can switch to another cluster, suppose you have 10 clusteres, always using kubeconfig file with kubectl command seems annoying. 
- To rid above problem is accessing multiple clusters using **Contexts**
- Define all the clusters and users in the 1 kubeconfig file.
- Define a context for each cluster.
- We can switch between clusters using these contexts.

#### What is a Context?
- Combination of which user should access to which cluster.
- Use the credentials of the kubernetes-admin user to access the kubernetes cluster in the kubeconfig file.
- Multiple clusters, users and contexts defines in the kubeconfig file, when we will use kubectl command kubectl connect to user defines in **current-context** attribute.
- We can switch the context by changing **current-context** attribute
- Instead of manually change the **current-context** attribute in the file, try to use **use-context** by kubectl command.

```
kubectl config --help

kubectl config use-context

kubectl config get-contexts

kubectl config current-contexts

```

#### Namespace in contexts
- Each context consists actually of 3 components: 1. Cluster 2. User 3. Namespace
- By default, the **default** namespace is configured.
- Other than default namespace, we need to define them. Change it throuh contexts.

```
kubectl config set-context --current --namespace=kube-system

cat ~/.kube/config
```