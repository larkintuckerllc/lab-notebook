# AWS Elastic Cloud Compute (EC2)

> Amazon Elastic Compute Cloud (Amazon EC2) is a web service that provides secure, resizable compute capacity in the cloud. It is designed to make web-scale cloud computing easier for developers. Amazon EC2’s simple web service interface allows you to obtain and configure capacity with minimal friction. It provides you with complete control of your computing resources and lets you run on Amazon’s proven computing environment.

[Amazon EC2](https://aws.amazon.com/ec2/)

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
