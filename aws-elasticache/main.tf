provider "aws" {
  region = "us-east-1"
}

locals {
  identifier = "aws-elasticache"
}

data "aws_subnet_ids" "this" {
  vpc_id = var.vpc_id
}

resource "aws_security_group" "this" {
  name   = local.identifier
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "this_ingress_all" {
  from_port   = 0
  protocol    = "-1"
  security_group_id = aws_security_group.this.id
  source_security_group_id = aws_security_group.this.id
  to_port     = 0
  type        = "ingress"
}

resource "aws_security_group_rule" "this_egress" {
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 0
  protocol    = "-1"
  security_group_id = aws_security_group.this.id
  to_port     = 0
  type        = "egress"
}

