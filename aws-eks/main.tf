provider "aws" {
  region = "us-east-1"
}

locals {
  identifier = "aws-eks"
}

module "vpc" {
  source = "./modules/vpc"
  identifier = local.identifier
}

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
