# Kubernetes Template Kustomize (b)

Depends on *k8s-template-kustomize-a*.

## Commands

```
kubectl apply -k infrastructure
```

Validate that Pod gets environment variable that matches ClusterIP address:

```
kubectl exec api-7f85876645-nxwbt -- curl 10.152.183.201
```
