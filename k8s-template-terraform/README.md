# Kubernetes Template Kustomize (b)

Uses image from microK8s repository from *k8s-template-none*.

## Commands

```
terraform apply
```

Validate that Pod gets environment variable that matches ClusterIP address:

```
kubectl exec api-7f85876645-nxwbt -- curl 10.152.183.201
```
