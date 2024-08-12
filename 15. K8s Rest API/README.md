#### Access REST API with kubectl proxy
- Location of cluster = Endpoint of API SERVER https://kube-api-server:8080
- Credentials to authenticate.
- **First way:** access using kubectl and its configuration.

    kubectl config view

- here we can see the locations and credentials that kubectl knows about when accessing the cluster.
- **Second way:** Directly accesing REST API with curl, wget and browser 
1. Using kubectl proxy. Kubectl will run in proxy mode. It uses the stored apiserver location and verifies the identity of the API server using a self-signed cert.
    
    kubectl proxy --port 8080 &
    curl http://localhost:8080/api/
    curl http://localhost:8080/api/v1

#### Access REST API without kubectl proxy
- We need to pass aithentication ourselves that needs authenticated user.
- Now lets say, we want to write a script that accessing kubernetes endpoints and basically cleans up some old services, deployments that are not being used. Execute script with a user with limited permissions. We want to execute this as an admin user. For non human user we have service account. Now create service account with role and rolebinding, connect to REST API.

    kubectl create serviceaccount myscript

    vim myscript-role.yaml   

##### Check ```myscript-role.yaml``` file

    kubectl apply -f myscript-role.yaml   

    kubectl create rolebinding script-role-binding --role=myscript-role --serviceaccount=default:myscript

    kubectl get seviceaccount myscript -o yaml       ------ here you can find secrets name with token in it.

    kubectl get secret mysecret-token<full-path> -o yaml   -- here you can find token

    echo <token> | base64 --decode | tr -d "\n"

    TOKEN=<decoded-token>   ---------- Save this into a variable.

    SERVER=https://<ip>:<port>   ----- find the ip and port in-- kubectl config view and keep it into SERVER variable 

##### Connceting with k8s REST API
    curl -X GET $SERVER/api "Authorization: Bearer $TOKEN" --cacert /etc/kubernetes/pki/ca.crt
    ---- Here, curl = HTTP client to connect to HTTP server, The api server expects an "Authorization" header

    curl -X GET $SERVER/api/v1/namespaces/default/services "Authorization: Bearer $TOKEN" --cacer /etc/kubernetes/pki/ca.crt

    curl -X GET $SERVER/api "Authorization: Bearer $TOKEN" --insecure    # insecure is used for not required certification validation from server.

##### Chcek all commands on ```commands.md``` file


##### How k8s REST API is structured
**API Groups**
- Part of k8s API
- Different k8s resources belong to different API groups.
- Pods, svc in core API group, REST Path: /api/v1
- Deployments, statefulset in apps API grou, REST Path: /apis/apps/v1
- So, whenever we need to get a component and data, we need to specify API group in the request. 


#### Programmatic Access to the API
- Instead of simple shell scripts, use a programmimg language.
- k8s officially supports client libraries for Go, Python, JavaScript etc.
- With client libraries do not need to implement the API calls and request/response types yourself.
- There has unofficial client libraries for other programming languages as well.