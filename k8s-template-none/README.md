# Kubernetes Template None 

## Commands

**Local Development**

Install application dependencies; from *app* folder:

```
pipenv install
```

Run application; from *app* folder:

```
export API_SERVICE_HOST=127.0.0.1
export FLASK_APP=main.py
pipenv run flask run
```

**Publish to microK8s Repository**

```
docker build -t api .  

docker tag api:latest localhost:32000/api

docker push localhost:32000/api
```

**Validating**

```
kubectl apply -f cluster-ip.yaml

kubectl apply -f deployment.yaml
```

Validate that Pod gets environment variable that matches ClusterIP address:

```
kubectl exec api-7f85876645-nxwbt -- curl 10.152.183.201
```
