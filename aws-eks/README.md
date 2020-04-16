# Elastic Kubernetes Service (EKS)

> Amazon Elastic Kubernetes Service (Amazon EKS) is a fully managed Kubernetes service. Customers such as Intel, Snap, Intuit, GoDaddy, and Autodesk trust EKS to run their most sensitive and mission critical applications because of its security, reliability, and scalability.

[Amazon Elastic Kubernetes Service](https://aws.amazon.com/eks/)

## Network Diagram

![Network Diagram](aws-ecs.png)

## Resources

**VPC**

CIDR Block: 10.0.0.0/16

**Subnet (S0 - Public)**

Availability Zone: us-east-1a
CIDR Block: 10.0.0.0/24

**Subnet (S1 - Public)**

Availability Zone: us-east-1b
CIDR Block: 10.0.1.0/24

**Subnet (S2 - Public)**

Availability Zone: us-east-1c
CIDR Block: 10.0.2.0/24

**Subnet (S10 - Private)**

Availability Zone: us-east-1a
CIDR Block: 10.0.10.0/24

**Subnet (S11 - Private)**

Availability Zone: us-east-1b
CIDR Block: 10.0.11.0/24

**Subnet (S12 - Private)**

Availability Zone: us-east-1c
CIDR Block: 10.0.12.0/24

**Internet Gateway**

**NAT Gateway (S0)**

Subnet: S0

**NAT Gateway (S1)**

Subnet: S1

**NAT Gateway (S2)**

Subnet: S2

**Route Table (Public: S0, S1, S2)**

| Destination | Target |
| ----------- | ------ |
| 10.0.0.0/16 | local  |
| 0.0.0.0/0   | IG     |

**Route Table (S10)**

| Destination | Target |
| ----------- | ------ |
| 10.0.0.0/16 | local  |
| 0.0.0.0/0   | NG S0  |

**Route Table (S11)**

| Destination | Target |
| ----------- | ------ |
| 10.0.0.0/16 | local  |
| 0.0.0.0/0   | NG S1  |

**Route Table (S12)**

| Destination | Target |
| ----------- | ------ |
| 10.0.0.0/16 | local  |
| 0.0.0.0/0   | NG S2  |

**NACL (Public Inbound)**

| Rule | Type | Protocol | Port | Source    | A/D   |
| ---- | ---- | -------- | ---- | --------- | ----- |
| 100  | ALL  | ALL      | ALL  | 0.0.0.0/0 | Allow |
| *    | ALL  | ALL      | ALL  | 0.0.0.0/0 | Deny  |

**NACL (Public Outbound)**

| Rule | Type | Protocol | Port | Dest      | A/D   |
| ---- | ---- | -------- | ---- | --------- | ----- |
| 100  | ALL  | ALL      | ALL  | 0.0.0.0/0 | Allow |
| *    | ALL  | ALL      | ALL  | 0.0.0.0/0 | Deny  |

**NACL (Private Inbound)**

| Rule | Type | Protocol | Port       | Source      | A/D   |
| ---- | ---- | -------- | ---------- | ----------- | ----- |
| 100  | HTTP | TCP      | 80         | 10.0.0.0/16 | Allow |
| 300  | CUST | TCP      | 1024-65535 | 0.0.0.0/0   | Allow |
| 400  | CUST | UDP      | 1024-65535 | 0.0.0.0/0   | Allow |
| 500  | HTTP | TCP      | 22         | 10.0.0.0/16 | Allow |
| *    | ALL  | ALL      | ALL        | 0.0.0.0/0   | Deny  |

**NACL (Private Outbound)**

| Rule | Type | Protocol | Port | Dest      | A/D   |
| ---- | ---- | -------- | ---- | --------- | ----- |
| 100  | ALL  | ALL      | ALL  | 0.0.0.0/0 | Allow |
| *    | ALL  | ALL      | ALL  | 0.0.0.0/0 | Deny  |


**Security Group (Bastion) Inbound**

| Type  | Protocol | Port Range | Source       |
| ----- | -------- | ---------- | ------------ |
| ALL   | ALL      | ALL        | SG (Bastion) |
| SSH   | TCP      | 22         | 0.0.0.0/0    |
| HTTPS | TCP      | 443        | 0.0.0.0/0    |

**Security Group (Bastion) Outbound**

| Type  | Protocol | Port Range | Destination |
| ----- | -------- | ---------- | ----------- |
| ALL   | ALL      | ALL        | 0.0.0.0/0   |






resource "aws_dynamodb_table" "this" {
  attribute {
    name = "Id"
    type = "S"
  }
  hash_key         = "Id"
  name             = "Todos"
  read_capacity    = 1
  write_capacity   = 1
}

# ROLES

resource "aws_iam_role" "eks_service" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  name               = "${local.identifier}-eksServiceRole"
}

resource "aws_iam_role_policy_attachment" "eks_service_service" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_service.id
}

resource "aws_iam_role_policy_attachment" "eks_service_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_service.id
}

resource "aws_iam_role" "node_instance" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  name               = "${local.identifier}-NodeInstanceRole"
}

resource "aws_iam_role_policy_attachment" "node_instance_worker" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_instance.id
}

resource "aws_iam_role_policy_attachment" "node_instance_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_instance.id
}

resource "aws_iam_role_policy_attachment" "node_instance_registry" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_instance.id
}

# SECURITY GROUPS

resource "aws_security_group" "cluster" {
  name   = "${local.identifier}-cluster"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "cluster_ingress" {
  from_port         = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.cluster.id
  security_group_id = aws_security_group.cluster.id
  to_port           = 0
  type              = "ingress"
}

resource "aws_security_group_rule" "cluster_egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.cluster.id
  to_port           = 0
  type              = "egress"
}

# CLUSTER RESOURCES

resource "aws_eks_cluster" "this" {
  depends_on = [
    aws_iam_role_policy_attachment.eks_service_service,
    aws_iam_role_policy_attachment.eks_service_cluster
  ]
  name     = local.identifier
  role_arn = aws_iam_role.eks_service.arn
  vpc_config {
    security_group_ids = [aws_security_group.cluster.id]
    subnet_ids = module.vpc.subnet_ids
  }
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  depends_on = [
    aws_iam_role_policy_attachment.node_instance_worker,
    aws_iam_role_policy_attachment.node_instance_cni,
    aws_iam_role_policy_attachment.node_instance_registry
  ]
  node_group_name = local.identifier
  node_role_arn   = aws_iam_role.node_instance.arn
  remote_access {
    ec2_ssh_key = var.key_name
    source_security_group_ids = [module.vpc.bastion_security_group_id]
  }
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }
  subnet_ids      = module.vpc.private_subnet_ids
  tags = {
    Name = local.identifier
  }
}

# IAM ROLES FOR SERVICE ACOUNTS (default:api)

# HACK: https://github.com/terraform-providers/terraform-provider-aws/issues/10104
data "external" "thumbprint" {
  program = ["sh", "thumbprint.sh", data.aws_region.this.name]
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.external.thumbprint.result.thumbprint]
  url             = aws_eks_cluster.this.identity.0.oidc.0.issuer
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.this.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:api"]
    }
    effect  = "Allow"
    principals {
      identifiers = ["${aws_iam_openid_connect_provider.this.arn}"]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "api" {
  assume_role_policy = data.aws_iam_policy_document.this.json
  name               = "${local.identifier}-APIRole"
}

resource "aws_iam_role_policy" "api_dynamodb_write" {
  name = "DynamoDBWrite"
  role = aws_iam_role.api.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem",
                "dynamodb:DeleteItem",
                "dynamodb:Scan"
            ],
            "Resource": "${aws_dynamodb_table.this.arn}"
        }
    ]
}
  EOF
}














## Commands

**Setup Kubernetes CLI**

Remove existing Kubernetes CLI configuration

```
rm -f -r ~/.kube/
```

Create new Kubernetes CLI configuration

```
aws eks --region us-east-1 update-kubeconfig --name aws-eks
```

**Local Development - Hello World**

Install application dependencies; from *app-hello-world* folder:

```
pipenv install
```

Run application; from *app-hello-world* folder:

```
export LOCALHOST=true
export FLASK_APP=main.py
pipenv run flask run
```

**Publish to Elastic Container Repository - Hello World**

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
docker build -t aws-eks-hello-world -f Dockerfile-hello-world .
```

Tag image for ECR repository:

```
docker tag aws-eks-hello-world:latest 143287522423.dkr.ecr.us-east-1.amazonaws.com/aws-eks-hello-world:latest
```

Push image to ECR repository:

```
docker push 143287522423.dkr.ecr.us-east-1.amazonaws.com/aws-eks-hello-world:latest

```

**Publish to Elastic Container Repository - API**

First, create ECR repository, e.g., with AWS Console.

```
docker build -t aws-eks-api -f Dockerfile-api .
```

Tag image for ECR repository:

```
docker tag aws-eks-api:latest 143287522423.dkr.ecr.us-east-1.amazonaws.com/aws-eks-api:latest
```

Push image to ECR repository:

```
docker push 143287522423.dkr.ecr.us-east-1.amazonaws.com/aws-eks-api:latest
```

**Learning EKS by Example**

Examples provide by [AWS Elastic Kubernetes Service (EKS) By Example](https://codeburst.io/aws-elastic-kubernetes-service-eks-by-example-82016b467295)

The *hello-world.yml* (using ECR) and *api.yml* (using ECR and AWS roles) examples are more complicated examples.
