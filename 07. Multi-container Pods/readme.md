## Multi-Container Pods
##### Use cases
- Updates the cache 
- Doing authentication tasks.
- Collects logs.
- Helper Applicaition 
- Those are not part of the main application.
- Helper application for the main app.
- Script that runs before each app start-up.
- Preparing environment before app start-up.

## Init and Sidecar Containers
- You can have Multiple containers inside the pod.
- Main and helper application.

### Sidecar Containers
- Helper application technical name is **Sidecar Container**. The container providing helper functionality is called sidecar container.
- Sidecar application run parallel and synchronise data, collecting logs with main application.
- Usually operate asynchronously.
- Sidecar can talk to each other using localhost and can share data with main container.
- Can have multiple sidecar container in a pod.
- Run **side-by-side** with your main container.
- Start at same time.

### Init Containers
- Run once in the beginning and exits.
- Start init containers first, Main container starts **afterwards**
- Init containers are used to **initialize** something inside your pod.
- Preparing environment: set environment variables, system checks, wait for service to be available use of init containers.

### Apply ```multi-container-init-sidecar.yaml``` file
    kubectl apply -f multi-container-sidecar.yaml

    kubectl get pod

    kubectl logs <pod_name> -c <container_name>   # When you have multiple containers you always need to specify the container.

### Apply ```multi-container-init-sidecar.yaml``` file
    kubectl apply -f multi-container-init.yaml
    
    kubectl get pod 

    kubectl logs <pod_name> -c <container_name>   # When you have multiple containers you always need to specify the container.  

    add mydb service as yaml manifest
    kubectl create service clusterip mydb-service --tcp=80:80

    kubectl get svc

    kubectl logs <pod_name> -c <container_name>

    kubectl get pod


## Expose Pod Information to Container 
- You need some data about Pod or K8s environment in your application. Ex: pod IP address, pod Namespace, Service account of Pod, add pod information as metadata to logs etc.
- All pod information can be made available in the config file.

    kubectl get pod -o yaml 

- There are 2 ways to expose pod fields to a running container:
    1. Environment Variables
    2. Volume Files.

- Check ```multi-container-env.yaml``` file for exposing pod.