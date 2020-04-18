# Kubernetes Storage

[Kubernetes Storage](https://kubernetes.io/docs/concepts/storage/)

## Commands

**emptyDir Volume**

```
kubectl apply -f empty-dir.yml

kubectl exec -it pod/empty-dir --container busybox-a -- /bin/sh

ls /cache
touch /cache/hello-cache

kubectl exec -it pod/empty-dir --container busybox-b -- /bin/sh

ls /cache

kubectl delete -f empty-dir.yml
```

**Persistent Volume**

```
kubectl apply -f persistent-volume.yml

kubectl exec -it pod/persistent-volume -- /bin/sh

touch /disk/hello-disk

kubectl delete pod/persistent-volume

kubectl apply -f persistent-volume.yml

kubectl exec -it pod/persistent-volume -- /bin/sh

ls /disk

kubectl delete -f persistent-volume.yml
```

**Persistent Volume Many**

```
kubectl apply -f persistent-volume-many.yml
```

Repeat above for:

- pod/persistent-volume-many-a
- pod/persistent-volume-many-b

```
kubectl delete -f persistent-volume-many.yml
```