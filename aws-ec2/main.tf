provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "this" {
  name   = "aws-ec2"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "this_ingress_https" {
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 443
  protocol    = "tcp"
  security_group_id = aws_security_group.this.id
  to_port     = 443
  type        = "ingress"
}

resource "aws_security_group_rule" "this_ingress_ssh" {
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 22
  protocol    = "tcp"
  security_group_id = aws_security_group.this.id
  to_port     = 22
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
