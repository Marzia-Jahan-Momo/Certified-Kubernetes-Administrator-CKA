#### Existing certificates generaeted by kubeadm
    ls /etc/kubernetes/pki 

#### check certificate expirations dates of all k8s certificates with kubeadm
    kubeadm --help

    kubeadm certs --help
    
    sudo kubeadm certs check-expiration

- Client certificates expire after 1 year.
- CA certificates expite after 10 years.

    sudo kubeadm certs renew --help

    ls /etc/kubernetes/pki   --- based on the files renew it

#### check expiration date of a certificate with openssl
    openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout

#### filter resulting cert for validity attribute plus 2 following lines
    openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout | grep Validity -A2

#### Note
- If you upgraded the cluster, Kubeadm renews certificates during the cluster upgrade.
- You should actually upgrade regularly thats why you can get certificate renewable automatically. Don't have to manually renew it, kubeadm will take care of it.