**emptyDir Volume**

kubectl apply -f empty-dir.yml

kubectl exec -it pod/empty-dir --container busybox-a -- /bin/sh

ls /cache
touch /cache/hello-cache

kubectl exec -it pod/empty-dir --container busybox-b -- /bin/sh

ls /cache

kubectl delete -f empty-dir.yml

**Persistent Volume**

kubectl apply -f persistent-volume.yml

kubectl exec -it pod/persistent-volume -- /bin/sh

touch /disk/hello-disk

kubectl delete pod/persistent-volume

kubectl apply -f persistent-volume.yml

kubectl exec -it pod/persistent-volume -- /bin/sh

ls /disk

kubectl delete -f persistent-volume.yml

