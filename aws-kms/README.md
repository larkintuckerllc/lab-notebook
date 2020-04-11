# AWS Elastic Cloud Compute (EC2)

> Amazon Elastic Compute Cloud (Amazon EC2) is a web service that provides secure, resizable compute capacity in the cloud. It is designed to make web-scale cloud computing easier for developers. Amazon EC2’s simple web service interface allows you to obtain and configure capacity with minimal friction. It provides you with complete control of your computing resources and lets you run on Amazon’s proven computing environment.

[Amazon EC2](https://aws.amazon.com/ec2/)

## Network Diagram

![Network Diagram](aws-ec2.png)

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


**Commands**

aws kms encrypt \
  --key-id  alias/aws-kms \
  --plaintext fileb://hello.txt \
  --output text \
  --query CiphertextBlob | \
  base64 \
  --decode > \
  hello-encrypted.bin

aws kms decrypt \
  --ciphertext-blob fileb://hello-encrypted.bin \
  --output text \
  --query Plaintext | \
  base64 \
  --decode > \
  hello-decrypted.txt

aws kms generate-data-key \
  --key-id alias/aws-kms \
  --key-spec AES_256 > \
  data-key.json

echo "3mQInAUpWXS9JQwjh0OH8TMfK8CKVe6ZkjeRahLzlwo=" | openssl base64 -d > plaintext_key_decoded

openssl enc -e -aes256 \
  -kfile plaintext_key_decoded \
  -in hello.txt \
  -out hello-data-key-encrypted.bin

aws kms decrypt \
  --ciphertext-blob "AQIDAHiZ5FHa8awHvx35tlP/29CLGD3rdjkAKYI/kKgaWhRHggHWx3NLFD1DPXFYvVUdWY4JAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMJkX+ov4sfKP2ftmWAgEQgDsK6oH0P0EQaB5U0t55JgFyXyX0ZDWqyTaP+DV4JCtYCvNrPm7VtEv3saBQVTY9WpFnk6YsfsgQ5eNmoA==" \
  --query 'Plaintext' \
  --output text | openssl base64 -d -out plaintext_key_decoded

openssl enc -d -aes256 \
  -kfile plaintext_key_decoded \
  -in hello-data-key-encrypted.bin \
  -out hello-data-key-decrypted.txt

