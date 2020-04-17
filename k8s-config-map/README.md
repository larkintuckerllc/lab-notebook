# Kubernetes ConfigMap

> 

[]()

## Commands

**ConfigMap with Key-Value Entries (CLI options)**

Create ConfigMap:

```
kubectl create configmap example \
  --from-literal=A=apple \
  --from-literal=B=banana
```

Describe ConfigMap:

```
kubectl describe configmap example
```

Delete ConfigMap:

```
kubectl delete configmap example

```

**ConfigMap with Key-Value Entries (File)**

Create ConfigMap:

```
kubectl create configmap example \
  --from-env-file=fruit.env
```

Describe ConfigMap:

```
kubectl describe configmap example
```

**note**: Keep *example* for next section.

**ConfigMap Used in Container Command**

Create Pod:

```
kubectl apply -f command.yml
```

Log containter output:

```
kubectl logs pod/command
```

Clean-up

```
kubectl delete -f command.yml
```

**note**: Keep *example* for next section.

**ConfigMap Used in Container Environment**

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

Clean-up

```
kubectl delete -f environment.yml
kubectl delete configmap example
```

**ConfigMap with File Entries (Files)**

Create ConfigMap

```
kubectl create configmap example \
  --from-file=fruit=fruit.env \
  --from-file=dogs=dogs.env
```

Describe ConfigMap

```
kubectl describe configmap example
```

Clean-up

```
kubectl delete configmap example
```

**ConfigMap with File Entries (Directory)**

Create ConfigMap

```
kubectl create configmap example \
  --from-file=config
```

Describe ConfigMap

```
kubectl describe configmap example
```

**note**: Keep *example* for next section.

**ConfigMap Used in Container File System**

Create Pod:

```
kubectl apply -f file-system.yml
```

Login to Container:

```
kubectl exec -it pod/file-system -- /bin/sh
```

Use in file system:

```
cat /etc/config/fruit
```

Clean-up

```
kubectl delete -f file-system.yml
kubectl delete configmap example
```
