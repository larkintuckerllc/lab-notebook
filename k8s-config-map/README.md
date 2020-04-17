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

