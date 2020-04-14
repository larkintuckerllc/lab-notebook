# Elastic Container Service (ECS)

> Amazon Elastic Container Service (Amazon ECS) is a fully managed container orchestration service. Customers such as Duolingo, Samsung, GE, and Cook Pad use ECS to run their most sensitive and mission critical applications because of its security, reliability, and scalability.

[Amazon Elastic Container Service](https://aws.amazon.com/ecs/)

## Network Diagram

![Network Diagram](aws-ecs.png)

## Variables

- *certificate*: Wildcard certificate, e.g., **.todosrus.com*, of certificate (assume exists) for ELB  
- *repository*: ECR repository for Docker image (assume exists)
- *vpc_id*: Default VPC id (assume exists)
- *zone_name*: Zone name, .e.g., *todosrus.com", to create domain name (assume exists)

## Resources

**Security Group (SG LB) Inbound**

| Type  | Protocol | Port Range | Source    |
| ----- | -------- | ---------- | --------- |
| HTTPS | TCP      | 443        | 0.0.0.0/0 |

**Security Group (SG LB) Outbound**

| Type  | Protocol | Port Range | Destination |
| ----- | -------- | ---------- | ----------- |
| HTTP  | TCP      | 80         | SG Web    |


**Security Group (SG Web) Inbound**

| Type  | Protocol | Port Range | Source    |
| ----- | -------- | ---------- | --------- |
| HTTP  | TCP      | 80         | SG LB     |

**Security Group (SG Web) Outbound**

| Type  | Protocol | Port Range | Destination |
| ----- | -------- | ---------- | ----------- |
| ALL   | ALL      | ALL        | 0.0.0.0/0   |

**Target Group (TG)**

Protocol: HTTP

**Elastic Load Balancer (ELB) Listeners**

| Listener | Rules                                               |
| -------- | --------------------------------------------------- |
| HTTPS    | forwarding to TG                                    |

**Zone Records**

| Name                  | Type | Value     |
| --------------------- | ---- | --------- |
| aws-ecs.todosrus.com. | A    | ALIAS ELB |

**ECS Cluster**

**ECS Task Defintion**

**ECS Service**

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
