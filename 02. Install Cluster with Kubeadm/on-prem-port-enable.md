## For cloud users:
### Control plane
```
Protocol	   Direction			Port Range		Purpose						Used By
---------------------------------------------------------------------------------------------------------------------------------

TCP				Inbound		   6443			Kubernetes API server		All
TCP				Inbound		   2379-2380		etcd server client API		kube-apiserver, etcd
TCP				Inbound		   10250		Kubelet API			Self, Control plane
TCP				Inbound		   10259		kube-scheduler			Self
TCP				Inbound		   10257		kube-controller-manager		Self	
```


### Worker node(s)
```
Protocol	Direction	Port Range	Purpose			Used By
---------------------------------------------------------------------------------------------
TCP		Inbound		 10250		Kubelet API		Self, Control plane
TCP		Inbound		 10256		kube-proxy		Self, Load balancers
TCP		Inbound		 30000-32767	NodePort Services	All
```
---


## Who are using on prem chcek this:

### Master
	sudo firewall-cmd --add-port=443/tcp --permanent
	sudo firewall-cmd --add-port=80/tcp --permanent
	sudo firewall-cmd --add-port=6443/tcp --permanent
	sudo firewall-cmd --add-port=2379-2380/tcp --permanent
	sudo firewall-cmd --add-port=10250/tcp --permanent
	sudo firewall-cmd --add-port=10259/tcp --permanent
	sudo firewall-cmd --add-port=10257/tcp --permanent
	sudo firewall-cmd --add-port=6783/tcp --permanent
	sudo firewall-cmd --add-port=6784/tcp --permanent

### Worker
	sudo firewall-cmd --add-port=443/tcp --permanent
	sudo firewall-cmd --add-port=80/tcp --permanent
	sudo firewall-cmd --add-port=10250/tcp --permanent
	sudo firewall-cmd --add-port=30000-32767/tcp --permanent
	sudo firewall-cmd --add-port=6783/tcp --permanent
	sudo firewall-cmd --add-port=6784/tcp --permanent

sudo firewall-cmd --reload
sudo firewall-cmd --list-all
