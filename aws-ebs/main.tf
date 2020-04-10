provider "aws" {
  region = "us-east-1"
}

locals {
  identifier = "aws-ebs"
}

data "aws_subnet_ids" "this" {
  vpc_id = var.vpc_id
}

data "aws_ami" "this" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "ec2" {
  name   = "${local.identifier}-ec2"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "ec2_ingress_all" {
  from_port   = 0
  protocol    = "-1"
  security_group_id = aws_security_group.ec2.id
  source_security_group_id = aws_security_group.ec2.id
  to_port     = 0
  type        = "ingress"
}

resource "aws_security_group_rule" "ec2_ingress_ssh" {
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 22
  protocol    = "tcp"
  security_group_id = aws_security_group.ec2.id
  to_port     = 22
  type        = "ingress"
}

resource "aws_security_group_rule" "ec2_egress" {
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 0
  protocol    = "-1"
  security_group_id = aws_security_group.ec2.id
  to_port     = 0
  type        = "egress"
}

resource "aws_instance" "this" {
  ami                    = data.aws_ami.this.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2.id]
  subnet_id              = tolist(data.aws_subnet_ids.this.ids)[0]
  tags = {
    Name = local.identifier
  }
  user_data              = filebase64("user-data.sh")
}
