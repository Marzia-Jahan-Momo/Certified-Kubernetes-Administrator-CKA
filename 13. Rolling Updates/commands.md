##### Rollout Commands

#### Change existing image version and apply the deployment yaml file.
    kubectl get pod
    kubectl get rs
    kubectl describe pod <pod-name>
    kubectl rollout history deployment/{depl-name}
    kubectl rollout undo deployment/{depl-name}
    kubectl rollout status deployment/{depl-name}