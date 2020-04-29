# Kubernetes Ingress

First setup an AWS Cluster.

## Install Traefik

[Kubernetes Ingress Controller](https://docs.traefik.io/v1.7/user-guide/kubernetes/)

## Create Ingress with Traefik

```
kubectl apply -f deployment.yaml

kubectl apply -f cluster-ip.yaml

kubectl apply -f ingress.yaml
```
