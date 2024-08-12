- When Pod is in running state then it looks healthy.
- When a pod crashes, k8s restarts pod as k8s manages its resources intelligently.
- If container crashes, k8s doesn't know and developer need to restart it manually.

### Liveness Probes
- Using Liveness Probes kubernetes can know in which state of the application is, as of k8s automatically restart the application. 
- Liveness Probes is for application state.
- Liveness Probes perform health checks. Health checks only after container started.

#### How to configure Liveness Probes?
- Liveness Probes are 3 types of checking the health status.
1. **Exec probes:** kubelet executes the specified command to check the health.
2. **TCP Probes:** kubelet makes probe connection at the node, not in the pod.
3. **HTTP Probes:** kubelet sends an HTTP request to specified path and port. 

### Readiness Probes
- Readiness Probes perform health checks, let's k8s know if application is ready to recieve traffic.
- Without Readiness Probes, k8s assumes the app is ready to recieve traffic as soon as the container starts.

#### How to configure Readiness Probes?
- Configuration very similar to Liveness Probes.
- Both check applications availability.
- Only difference is Readiness Probes works during apllication startup & Liveness Probes using while application is running.
