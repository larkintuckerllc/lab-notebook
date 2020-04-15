provider "aws" {
  region = "us-east-1"
}

locals {
  identifier = "aws-eks"
}

data "aws_subnet" "a" {
  availability_zone = "us-east-1a"
}

data "aws_subnet" "b" {
  availability_zone = "us-east-1b"
}

/*
data "aws_acm_certificate" "this" {
  domain  = var.certificate
}

data "aws_route53_zone" "this" {
  name = "${var.zone_name}."
}
*/

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

resource "aws_security_group" "cluster" {
  name   = "${local.identifier}-cluster"
  vpc_id = var.vpc_id
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

resource "aws_eks_cluster" "this" {
  depends_on = [
    aws_iam_role_policy_attachment.eks_service_service,
    aws_iam_role_policy_attachment.eks_service_cluster
  ]
  name     = local.identifier
  role_arn = aws_iam_role.eks_service.arn
  vpc_config {
    security_group_ids = [aws_security_group.cluster.id]
    subnet_ids = [
      data.aws_subnet.a.id,
      data.aws_subnet.b.id
    ]
  }
}
