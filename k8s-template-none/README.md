**Local Development**

Install application dependencies; from *app* folder:

```
pipenv install
```

Run application; from *app* folder:

```
export API_SERVICE_HOST=development
export FLASK_APP=main.py
pipenv run flask run
```

docker build -t api .  

docker tag api:latest localhost:32000/api

docker push localhost:32000/api


START CLUSTER-IP

START DEPLOYMENT

Verify IP address
