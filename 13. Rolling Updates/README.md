#### What is ReplicaSet?
- Deployment creates an apllication rollout.
- ReplicaSet created automatically in the background, ensures that a specified number of pod replicas are running at any given time.

#### Deployment(we work with deploymet) > ReplicaSet(k8s creates ReplicaSet in background) > Pods(ReplicaSet creates Pod)

### In which oder do pods get removed and new ones created? Deployment strategies
1. **Recreated Strategy:** All existing pods are killed before new ones are created. It will result an application downtime. Application will be unavailable.
2. **Rolling Update Strategy:** The Deployment updates pods in a rolling update fashion. It delete one pod and create one, after it delete second pod and creates second one, and thus go on. It reduce application downtime. No application downtime. It is the default update strategy. You can find explicitly in describe command [StrategyType]
- You can specify how many pods to update at once. 
- **Max Unavailabe:** Specifies the max number of pods that can be unavailable during the update process.
- **Max Surge:** Specifies the max number of pods that can be created over the desired number of pods.

##### ReplicaSet and its pods are linked. Name of ReplicaSet: [deployment-name]-[random-string] & Name of Pod: [deployment-name]-[replicaset-suffix]-[random-string]

#### Rollout History
- When a deployment rollout is triggered, a new deployment revision is created.
- Note: A new revision is only created when the deployment's pod template is changed.