rm -f -r ~/.kube/

aws eks --region us-east-1 update-kubeconfig --name aws-eks

kubectl get svc

kubectl get nodes
