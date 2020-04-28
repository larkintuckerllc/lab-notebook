# Kubernetes Secret

> Kubernetes Secrets let you store and manage sensitive information, such as passwords, OAuth tokens, and ssh keys

[Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)

## Commands

**Secret**

Create Secret

```
kubectl apply -f secret.yaml
```

Describe ConfigMap:

```
kubectl describe secret secret
```

**Secret Used in Container Environment**

Create Pod:

```
kubectl apply -f environment.yml
```

Login to Container:

```
kubectl exec -it pod/environment -- /bin/sh
```

Use in environment:

```
echo $A
```

**Secret Used in Container Command**

Create Pod:

```
kubectl apply -f command.yml
```

Log Container:

```
kubectl logs command
```

**Secret Used in Container File System** 

Create Pod:

```
kubectl apply -f file-system.yml
```

Login to Container:

```
kubectl exec -it pod/environment -- /bin/sh
```

View file system:

```
ls /etc/secrets
```

