### Resource Request
- Resquests is what the container is guranteed to get.
- K8s schedular uses this to figure out where to run the pods.
- Configure resource requests for each container.

### Resource Limit
- Container is only allowed to go up to the limit.
- Make sure container never goes above a certain value.
- Configure resource limits for each container.

### Which pods have resource request and limits set?
```
kubectl get pod -o jsonpath="{range .items[*]} {.metadata.name} {.spec.containers[*].resources} {'\n'}"
```

- When a node out of resources, Pods which have no request set are evicted first.