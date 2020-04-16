rm -f -r ~/.kube/

aws eks --region us-east-1 update-kubeconfig --name aws-eks

kubectl get svc

kubectl get nodes



Install application dependencies; from *app* folder:

```
pipenv install
```

Run application; from *app* folder:

```
export LOCALHOST=true
export FLASK_APP=main.py
pipenv run flask run
```



First, create ECR repository, e.g., with AWS Console.

Login Docker CLI to ECR:

```
aws ecr get-login-password \
  --region us-east-1 |\
docker login \
  --username AWS \
  --password-stdin \
  143287522423.dkr.ecr.us-east-1.amazonaws.com
```

Build Docker image:

```
docker build -t aws-eks-hello-world -f Dockerfile-hello-world .
```

Tag image for ECR repository:

```
docker tag aws-eks-hello-world:latest 143287522423.dkr.ecr.us-east-1.amazonaws.com/aws-eks-hello-world:latest
```

Push image to ECR repository:

```
docker push 143287522423.dkr.ecr.us-east-1.amazonaws.com/aws-eks-hello-world:latest

```


```
docker build -t aws-eks-api -f Dockerfile-api .
```

Tag image for ECR repository:

```
docker tag aws-eks-api:latest 143287522423.dkr.ecr.us-east-1.amazonaws.com/aws-eks-api:latest
```

Push image to ECR repository:

```
docker push 143287522423.dkr.ecr.us-east-1.amazonaws.com/aws-eks-api:latest
```

aws eks describe-cluster --name aws-eks --query "cluster.identity.oidc.issuer" --output text
