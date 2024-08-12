### etcd
- A distributed, reliable key-value store.
- Periodically backing up the etcd cluster data is important.
- All deployment, svc, configmap, revisions everything stores in the etcd. If we lost etcd data, we will lose all the information data and we would not know the cluster state.


##### **Not stored inside etcd:**
- Application Data is not stored in it.  
- Storage configured with Persistent Volume is for applicaiton data.