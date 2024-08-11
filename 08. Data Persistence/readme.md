#### Kubernetes do not provide data persistence out of the box. Volume is directory with some data. You explicitly configure data persistence. For Data Persistence there has 3 type of volumes:
1. **Persistant Volume:** It is like a cluster resource, that store cpu, ram data as an example. PV needs actual physical storage like local hard drive or external nfs server or cloud storage. You need to create and manage them by yoursld. There has external plugin to your cluster. Spec attributes differ, depending on storage type. Created via YAML file.


**kind:** PersistentVolume
**spec:** How much storage? Depending on the type, the attributes of spec differ

- PV are not namespaced, They are accessible to the whole cluster.  

##### Local vs remote volume types:
- Each volume type has it's own use case!
- Local volume type violate means being tied to 1 specific node and surviving cluster crashes that requirement for data persistence.
- For DB persistence always use remote storage. 


2. **Persissent Volume Claim**
- Application has to claim the Persissent Volume with Persissent Volume Claim yaml file.  

##### Levels of volume abstractions
- Pod requests the volume through the PV claim
- Claim tries to find a volume in cluster.
- Volume has the actual storage backend that will create storage resource from.

##### Claims must be in the same namespace as pv.
- Volume is mounted into the pod.
- Volume is mounted into the container. 

- Admin provisions storage resource
- User creates claim to PV.

#### There has 2 volume types: 1. ConfigMap 2. Secret, both of them local volumes, not created via PV and PVC managed by Kubernetes. 
- Create ConfigMap or Secret component.
- Mount that into your pod/container.


3. **Storage Class**
- SC provisions PV dynamically, when PVC claims it. StorageBackend is defined in the SC component via 'provisioner' attribute
- Each storage backend has own provisioner. Internal provisioner - "kubernetes.io" and available external provisioner.
- Configure parameters for storage we want to request for PV.
- SC is another abstraction level, abstracts underlaying storage provider as well as parameters for that storage.
- Requested by PVC that add additional attribute storageClassName.
- Pod claims storage via PVC.
- PVC requests storage from SC.
- SC creates PV that meets the needs of the claim using provisioner from the actual storage backend.


#### Storage Requirements:
1. Storage that doesn't depend on the pod lifecycle, it will still stay if pod dies.
2. Storage or volume must be available on all nodes. 
3. Storage needs to survice even if cluster crashes. 

##### Remote storage systems persist data independent of the k8s node, where the data originated. You should use remote storage, especially in production.
##### For test purposes or when data is not so important you can use local volumes. Data is persisted on the k8s node. In local volumes there has **hostPath** volume.
**hostPath Volume- use in **CKA** exam:**            
- Simple configuration.
- But use only for single node testing. For multi-node cluster: use *Local* volume type instead.
- Also hostPath volumes present many security risk and its best practice to avoid the use of hostpaths when possible.

Steps:
1. Create PersistentVolume using hostPath as a storage volume - Data is stored on the local machine.
2. Create PersistentVolumeClaim - Binding Phase, request properties like capacity, accessmode, volumemode etc. Claim is automatically bound to the most suitable PV (based on the request properties.)
2. Create deployment to use volume.

##### Whenever you change the storage type, ex: you want to change hostPath to remote storage the only thing you need to update is Persistent Volume resource, everything else means pvc and deployment remains the same.  


#### Configure emptyDir Volume for sidecar
- Log Sidecar needs to access the log files. 
- Main container & sidecar container need shared location which both container can access. Don't need to be persisted. So,
- We need a storage that storage can be shared and no persistence necessary.
- Sidecar container also use for caching for that a volume type of **emptyDir** volume is needed. 
- Emptydir volume is suitable for multi-container pods. All containers in the pod can read and write the same files in the emptyDir Volume.
- EmptyDir volume is initially empty whenever pod restart, always starts from the fresh. 
- EmptyDir first created when a pod is assigned to a node and exists as long as that pod is running on that node.
- When pod is removed from a node, the data is deleted permanently.
- Data in EmptyDir is mouted into the containers file system. EmptyDir Mount path can be different for mnain container and for sidecar container. 