provider "aws" {
  region = "us-east-1"
}

locals {
  identifier = "aws-ebs"
}

data "aws_subnet" "this" {
  availability_zone = var.availability_zone
  vpc_id            = var.vpc_id
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

resource "aws_security_group_rule" "this_ingress_ssh" {
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 22
  protocol    = "tcp"
  security_group_id = aws_security_group.this.id
  to_port     = 22
  type        = "ingress"
}

resource "aws_security_group_rule" "this_ingress_html" {
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 80
  protocol    = "tcp"
  security_group_id = aws_security_group.this.id
  to_port     = 80
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

resource "aws_instance" "this" {
  ami                    = data.aws_ami.this.id
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 1
    volume_type = "gp2"
  }
  ebs_block_device {
    device_name = "/dev/sdg"
    volume_size = 1
    volume_type = "gp2"
  }
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.this.id]
  subnet_id              = data.aws_subnet.this.id
  tags = {
    Name = local.identifier
  }
  user_data              = filebase64("user-data.sh")
}