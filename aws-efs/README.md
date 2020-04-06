# AWS Elastic File System (EFS)

> Amazon EFS provides file storage for your Amazon EC2 instances. With Amazon EFS, you can create a file system, mount the file system on your EC2 instances, and then read and write data from your EC2 instances to and from your file system.

[Amazon Elastic File System (EFS)](https://aws.amazon.com/efs/)

# TODO FIX

## Network Diagram

![Network Diagram](aws-ec2.png)

## Variables

- *domain*: Domain name, e.g., *aws-ec2.todosrus.com*, for certificate (assume exists) and ELB  
- *key_name*: EC2 key pair name (assume exists)
- *vpc_id*: Default VPC id (assume exists)
- *zone_name*: Zone name, .e.g., *todosrus.com.", to create domain name (assume exists)

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
