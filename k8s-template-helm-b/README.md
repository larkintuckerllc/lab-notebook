# Kubernetes Template Helm (b)

Depends on *k8s-template-helm-a*.

## Commands

```
helm install b infrastructure
```

Validate that Pod gets environment variable that matches ClusterIP address:

```
kubectl exec api-7f85876645-nxwbt -- curl 10.152.183.201
```
