# Kubernetes ConfigMap

> ConfigMaps allow you to decouple configuration artifacts from image content to keep containerized applications portable. 

[Configure a Pod to Use a ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#define-container-environment-variables-using-configmap-data)

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

**ConfigMap with File Entries (JSON File) and Used in Container File System**

Create ConfigMap

```
kubectl create configmap example \
  --from-file=fruit.json 
```

Describe ConfigMap

```
kubectl describe configmap example
```

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
cat /etc/config/fruit.json
```

Clean-up

```
kubectl delete -f file-system.yml
kubectl delete configmap example
```

**ConfigMap with Key-Value Entries (Configuration File)**

Create ConfigMap

```
kubectl apply -f fruit.yml
```

Describe ConfigMap

```
kubectl describe configmap example
```

Clean-up

```
kubectl delete configmap example
```

**ConfigMap with Key-Value Entries (ConfigMapGenerator)**

Create ConfigMap

```
kubectl apply -k .
```

Describe ConfigMap

```
kubectl describe configmap
```

Clean-up

```
kubectl delete configmap example-b9b8ftm6d8
```

**note:**: Suffix will vary.
