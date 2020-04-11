# Amazon Elastic Block Store (EBS)

> Amazon Elastic Block Store (EBS) is an easy to use, high performance block storage service designed for use with Amazon Elastic Compute Cloud (EC2) for both throughput and transaction intensive workloads at any scale. A broad range of workloads, such as relational and non-relational databases, enterprise applications, containerized applications, big data analytics engines, file systems, and media workflows are widely deployed on Amazon EBS.

[Amazon Elastic Block Store](https://aws.amazon.com/ebs/)

## Network Diagram

![Network Diagram](aws-ebs.png)

## Variables

- *availability_zone*: Which availability zone to run EC2 and EBS in
- *key_name*: EC2 key pair name (assume exists)
- *vpc_id*: Default VPC id (assume exists)

## Resources

**Security Group (SG) Inbound**

| Type  | Protocol | Port Range | Source    |
| ----- | -------- | ---------- | --------- |
| ALL   | ALL      | ALL        | SG EC2    |
| SSH   | TCP      | 22         | 0.0.0.0/0 |
| HTTP  | TCP      | 80         | 0.0.0.0/0 |

**Security Group (SG) Outbound**

| Type  | Protocol | Port Range | Destination |
| ----- | -------- | ---------- | ----------- |
| ALL   | ALL      | ALL        | 0.0.0.0/0   |

**Elastic Cloud Compute (EC2)**

AMI: Amazon Linux 2 AMI (HVM), SSD Volume Type

EBS: 1GB /dev/sdf
EBS: 1GB /dev/sdg

RAID 0: /dev/sdf, /dev/sdg => /dev/md0
Disk (GB): 2
IOPS / s: 100 x 2 = 200
IOPS Burst / s: 3000 x 2 = 6000
I/O (KiB / IOPS): 256
Throughput (MiB / s): 51
Throughput Burst (MiB / s): 128 x 2 = 256 
