### Best way to create and pass external cofigurations in kubernetes is Configmap and Secret.

- Secret is for storing sensitive data and Configmap is for regular data. 
- Both allow you to decouple environment specific configuration from your container images.
- Pods can consume Configmap or Secret in 2 different ways: 
1. As individual values using environment variables or
2. As configuration files using volumes as often applications use a configuration file rather than just individual values.

### After applying all configuration files, if you want to change in the previous configmap or secret then the deplpyment won't restart automatically, so you need to delete all pods, and apply again. To make this more effectively use:
```
kubectl rollout restart deployment <previous-deployment-name>
```  

```
kubectl rollout status deployment <previous-deployment-name>
```

```
kubectl logs my-db-<full-path>
```