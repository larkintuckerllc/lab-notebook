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

**Persistent Volume (Dynamic)**

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

**Persistent Volume Many (Dynamic)**

```
kubectl apply -f persistent-volume-many.yml
```

Repeat above for:

- pod/persistent-volume-many-a
- pod/persistent-volume-many-b

```
kubectl delete -f persistent-volume-many.yml
```

**AWS EBS Peristent Volume (Dynamic)**

**note:** Use eksctl to create EKS cluster as the *aws-eks* example has a subtle issue.

Follow instructions in [How do I use persistent storage in Amazon EKS?](https://aws.amazon.com/premiumsupport/knowledge-center/eks-persistent-storage/)

```
kubectl apply -f aws-persistent-volume
```


