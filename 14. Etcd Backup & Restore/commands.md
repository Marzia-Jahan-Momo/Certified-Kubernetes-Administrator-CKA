### Install ectdctl
    sudo apt  install etcd-client

### Backup 

##### To see the kube-apiserver.yaml
    sudo cat /etc/kubernetes/manifests/kube-apiserver.yaml

    sudo cat /etc/kubernetes/manifests/etcd.yanl | grep /etc/kubernetes/pki

##### snapshot backup with authentication - here version can be change check documentation
    ETCDCTL_API=3 etcdctl snapshot save /tmp/etcd-backup.db \   
    --cacert /etc/kubernetes/pki/etcd/ca.crt \
    --cert /etc/kubernetes/pki/etcd/server.crt \
    --key /etc/kubernetes/pki/etcd/server.key


##### check snapshot status
    ETCDCTL_API=3 etcdctl --write-out=table snapshot status snapshotdb

    ETCDCTL_API=3 etcdctl --write-out=table snapshot status /tmp/etcd-backup.db


### Restore

##### create restore point from the backup
    sudo -i
    ETCDCTL_API=3 etcdctl snapshot restore /tmp/etcd-backup.db --data-dir /var/lib/etcd-backup

    Now we have to tell etcd to use new location 

##### the restored files are located at the new folder /var/lib/etcd-backup, so now configure etcd to use that directory:
    vim /etc/kubernetes/manifests/etcd.yaml

   - hostPath
        path: /var/lib/etcd-backup
    
    Note that: moutPath should be /var/lib/etcd only hostPath change to /var/lib/etcd-backup. Kubelet re-starts static pods automatically.


##### etcd path:
    sudo ls /var/lib/etcd

##### Better and more secure way to store etcd:
1. Use remote storage outside k8s cluster.
2. Run etcd outside k8s cluster. Instead of running etcd on master nodes, run them outside cluster.