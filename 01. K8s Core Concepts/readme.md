# Kubernetes Installation Steps

## On both Control Plane and Worker node:
    1. Container Runtime
    2. Kubelet
    3. Kube Proxy

## Only on Control Plane:
    1. Api server
    2. Scheduler 
    3. Controller Manager
    4. etcd 

# Static Pod
- Api server, Scheduler, Controller Manager, etcd - Those master components are static pods. 
- Static pod are managed directly by the kubelet daemon without control plane.


## Two things we need to consider:
- Kubernetes manifest file for each app
- Deployed securely (No unauthorized access & Encrypted communication)

## Pods are deployed by master components
-> Send request to API Server

-> Scheduler decides where to place pod

-> Pod data stored in etcd storage


## Regular Pod Scheduling:
-> API Server gets request 

-> Schedular defined in which pod

-> Kubelet schedules pod

### How does that word?
-> Kubelet watches a specific location on the Node it is running in  ``` /etc/kubernetes/manifest ``` Then it schedules pod, when it finds a "Pod" manifest.

-> Kubelet (Not Controller Manager) watches static pod and restarts if it fails.

-> Pod names are suffixed with the node hostname. 


## How to communicate components each other securely and establish mutual TLS connection so that their communication would be encrypted?
To communicate components each other securely and establish mutual TLS connection so that their communication would be encrypted - **we need certificates**

- Every components needs a certificate (without regular pods)

-> Generate self-signed CA certificate for kubernetes "cluster root CA"

-> Sign all client and server certificates with it.

-> Certificates are stored in ``` /etc/kubernetes/pki ``` folder.


## How certificates are used by your cluster through Public Key Infrastructure (PKI)
Kubernetes requires PKI for the following operations:
As API server is the middleman between client and server:

- Client certificates for the kubelet to authenticate to the API server
- Kubelet Server Certificates for the API server to talk to the kubelets
- Server certificate for the API server endpoint
- Server certificate for Etcd and kubelet
- Client certificates for administrators of the cluster to authenticate to the API server
- Client certificates for the API server to talk to the kubelets
- Client certificate for the API server to talk to etcd
- Client certificate/kubeconfig for the controller manager to talk to the API server
- Client certificate/kubeconfig for the scheduler to talk to the API server.

## Toolkit for bootstrapping a best practices k8s Cluster maintained by Kubernetes:
- Providing "fast paths" for creating k8s clusters.
- Performs the actions necessary to get a minimum viable cluster.
- Maintain all certificates.
- It cares only about the bootstrapping, not about provisioning machines.