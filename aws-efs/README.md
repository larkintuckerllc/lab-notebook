# AWS Elastic File System (EFS)

> Amazon Elastic File System (Amazon EFS) provides a simple, scalable, fully managed elastic NFS file system for use with AWS Cloud services and on-premises resources. It is built to scale on demand to petabytes without disrupting applications, growing and shrinking automatically as you add and remove files, eliminating the need to provision and manage capacity to accommodate growth.

[Amazon Elastic File System (EFS)](https://aws.amazon.com/efs/)

## Network Diagram

![Network Diagram](aws-efs.png)

## Variables

- *certificate*: Wildcard certificate, e.g., **.todosrus.com*, of certificate (assume exists) for ELB  
- *key_name*: EC2 key pair name (assume exists)
- *vpc_id*: Default VPC id (assume exists)
- *zone_name*: Zone name, .e.g., *todosrus.com", to create domain name (assume exists)

## Resources

**Security Group (SG) Inbound**

| Type  | Protocol | Port Range | Source    |
| ----- | -------- | ---------- | --------- |
| HTTP  | TCP      | 80         | 0.0.0.0/0 |
| ALL   | ALL      | ALL        | SG        |
| SSH   | TCP      | 22         | 0.0.0.0/0 |
| HTTPS | TCP      | 443        | 0.0.0.0/0 |

**Security Group (SG) Outbound**

| Type  | Protocol | Port Range | Destination |
| ----- | -------- | ---------- | ----------- |
| ALL   | ALL      | ALL        | 0.0.0.0/0   |

**Target Group (TG)**

Protocol: HTTP

**Elastic Load Balancer (ELB) Listeners**

| Listener | Rules                                               |
| -------- | --------------------------------------------------- |
| HTTP     | redirecting to HTTPS://#{host}:443/#{path}?#{query} |
| HTTPS    | forwarding to TG                                    |

**Zone Records**

| Name                  | Type | Value     |
| --------------------- | ---- | --------- |
| aws-ec2.todosrus.com. | A    | ALIAS ELB |

**Launch Template (LT)**

AMI: Amazon Linux 2 AMI (HVM), SSD Volume Type

**Auto Scaling Group**

Launch Template: LT
Target Group: TG
