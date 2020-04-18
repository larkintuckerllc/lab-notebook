# Kubernetes DNS

[Kubernetes DNS for Service and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)

## Commands

**Service (Normal)**

```
kubectl apply -f normal.yml
kubectl exec -it ubuntu-pod -- /bin/bash
apt-get update
apt-get install dnsutils
```

Lookup *web* service

```
nslookup web
dig web.default.svc.cluster.local
```
