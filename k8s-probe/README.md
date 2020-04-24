# Kubernetes Probe

## Commands

**Local Development**

Start local Redis

```
docker-compose up -d
```

Install application dependencies; from *app* folder:

```
pipenv install
```

Run application; from *app* folder:

```
export REDIS_URL=redis://localhost
export FLASK_APP=main.py
pipenv run flask run
```

**Publish to microK8s Repository**

```
docker build -t todos .  

docker tag todos localhost:32000/todos:0.1.0

docker push localhost:32000/todos:0.1.0
```

**Validating**

```
helm install todos infrastructure
```

Watch Pods become unavailable to Service if dependency (Redis) is disabled.

```
kubectl scale deployment redis-todos --replicas=0

```
