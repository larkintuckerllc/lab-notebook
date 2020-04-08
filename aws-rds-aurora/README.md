# Amazon Relational Database Service (RDS) Server

> Amazon Relational Database Service (Amazon RDS) makes it easy to set up, operate, and scale a relational database in the cloud. It provides cost-efficient and resizable capacity while automating time-consuming administration tasks such as hardware provisioning, database setup, patching and backups. It frees you to focus on your applications so you can give them the fast performance, high availability, security and compatibility they need.

[Amazon Relational Database Service (RDS)](https://aws.amazon.com/rds/)

## Network Diagram

![Network Diagram](aws-rds-server.png)

## Variables

- *key_name*: EC2 key pair name (assume exists)
- *vpc_id*: Default VPC id (assume exists)

## Resources

**Security Group (SG EC2) Inbound**

| Type  | Protocol | Port Range | Source    |
| ----- | -------- | ---------- | --------- |
| ALL   | ALL      | ALL        | SG EC2    |
| SSH   | TCP      | 22         | 0.0.0.0/0 |

**Security Group (SG EC2) Outbound**

| Type  | Protocol | Port Range | Destination |
| ----- | -------- | ---------- | ----------- |
| ALL   | ALL      | ALL        | 0.0.0.0/0   |

**Security Group (SG RDS) Inbound**

| Type  | Protocol | Port Range | Source |
| ----- | -------- | ---------- | ------ |
| ALL   | ALL      | ALL        | SG RDS |
| CTM   | TCP      | 5432       | SG EC2 |

**Security Group (SG RDS) Outbound**

| Type  | Protocol | Port Range | Destination |
| ----- | -------- | ---------- | ----------- |
| ALL   | ALL      | ALL        | 0.0.0.0/0   |

**RDS**

Engine: postgres

**Elastic Cloud Compute (EC2)**

AMI: Amazon Linux 2 AMI (HVM), SSD Volume Type

## Command

`pgcli -h XXXXX -p 5432 -u postgres`
