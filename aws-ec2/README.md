# AWS Elastic Cloud Compute (EC2)

> Amazon Elastic Compute Cloud (Amazon EC2) is a web service that provides secure, resizable compute capacity in the cloud. It is designed to make web-scale cloud computing easier for developers. Amazon EC2’s simple web service interface allows you to obtain and configure capacity with minimal friction. It provides you with complete control of your computing resources and lets you run on Amazon’s proven computing environment.

[Amazon EC2](https://aws.amazon.com/ec2/)

![Network Diagram](aws-ec2.png)

**Zone**

| Name                  | Type | Value     |
| --------------------- | ---- | --------- |
| aws-ec2.todosrus.com. | A    | ALIAS ELB |

**Subnet Route Table (RT)**

| Destination   | Target |
| ------------- | ------ |
| 172.31.0.0/16 | local  |
| 0.0.0.0/0     | IGW    |

**Subnet Network Access Control List (NACL) Inbound**

| Rule # | Type | Protocol | Port Range | Source    | Allow / Deny |
| ------ | ---- | -------- | ---------- | --------- | ------------ |
| 100    | ALL  | ALL      | ALL        | 0.0.0.0/0 | ALLOW        |
| *      | ALL  | ALL      | ALL        | 0.0.0.0/0 | DENY         |

**Subnet Network Access Control List (NACL) Outbound**

| Rule # | Type | Protocol | Port Range | Source    | Allow / Deny |
| ------ | ---- | -------- | ---------- | --------- | ------------ |
| 100    | ALL  | ALL      | ALL        | 0.0.0.0/0 | ALLOW        |
| *      | ALL  | ALL      | ALL        | 0.0.0.0/0 | DENY         |

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
