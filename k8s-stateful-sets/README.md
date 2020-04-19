# Kubernetes StatefulSets

[Kubernetes StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)

## Commands

```
kubectl apply -f nginx-stateful-sets.yml
```

```
kubectl exec -it ubuntu-pod -- /bin/sh
```

```
apt-get update
apt-get install dnsutils
apt-get install curl
```

```
nslookup web
nslookup nginx-0.web
nslookup nginx-1.web
```

Login to nginx-0 and nginx-1 and create sample index.html in /usr/share/nginx/html

Login to ubuntu-pod and:

```
curl nginx-0.web
curl nginx-1.web
```

```
kubectl delete pod -l app=nginx
```

Login to ubuntu-pod and:

```
curl nginx-0.web
curl nginx-1.web
```
