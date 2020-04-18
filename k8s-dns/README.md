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
dig _http._tcp.web.default.svc.cluster.local SRV
dig nginx.web.default.svc.cluster.local
```

**Service (Headless)**

```
kubectl apply -f headless.yml
```

Same as above; except:

```
dig nginx-0.web.default.svc.cluster.local
dig nginx-1.web.default.svc.cluster.local
```
