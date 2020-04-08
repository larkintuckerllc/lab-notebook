# Amazon ElastiCache 

> Fully managed in-memory data store, compatible with Redis or Memcached. Power real-time applications with sub-millisecond latency.

[Amazon ElastiCache](https://aws.amazon.com/elasticache/)

## Network Diagram

![Network Diagram](aws-elasticache.png)

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

**Security Group (SG EC) Inbound**

| Type  | Protocol | Port Range | Source |
| ----- | -------- | ---------- | ------ |
| ALL   | ALL      | ALL        | SG EC  |
| CTM   | TCP      | 6379       | SG EC2 |

**Security Group (SG EC) Outbound**

| Type  | Protocol | Port Range | Destination |
| ----- | -------- | ---------- | ----------- |
| ALL   | ALL      | ALL        | 0.0.0.0/0   |

**ElastiCache**

Engine: Redis

**Elastic Cloud Compute (EC2)**

AMI: Amazon Linux 2 AMI (HVM), SSD Volume Type

## Command

`pgcli -h XXXXX -p 5432 -u postgres`
