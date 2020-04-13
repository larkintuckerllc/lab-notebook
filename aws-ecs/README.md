# TODO

> TODO

[TODO](TODO)

## Network Diagram

![Network Diagram](aws-ec2.png)

## Variables

- *certificate*: Wildcard certificate, e.g., **.todosrus.com*, of certificate (assume exists) for ELB  
- *vpc_id*: Default VPC id (assume exists)
- *zone_name*: Zone name, .e.g., *todosrus.com", to create domain name (assume exists)

## Resources

## Commands

**Local Development**

Start local DynamoDB:

```
docker-compose up -d
```

Create local *Todos* table:

```
sh scripts/create-table-localhost.sh
```

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

**Publish to Elastic Container Repository**

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
docker build -t aws-ecs .
```

Tag image for ECR repository:

```
docker tag aws-ecs:latest 143287522423.dkr.ecr.us-east-1.amazonaws.com/aws-ecs:latest
```

Push image to ECR repository:

```
docker push 143287522423.dkr.ecr.us-east-1.amazonaws.com/aws-ecs:latest

```
