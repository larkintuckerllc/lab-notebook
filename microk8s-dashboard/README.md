# MicroK8s Dashboard

[Dashboard addon](https://microk8s.io/docs/addon-dashboard)

Get token:

```
token=$(microk8s kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
microk8s kubectl -n kube-system describe secret $token
```

Start proxy server:

```
microk8s.kubectl proxy --accept-hosts=.* --address=0.0.0.0
```

Dashboard URL:

http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#/overview?namespace=default
