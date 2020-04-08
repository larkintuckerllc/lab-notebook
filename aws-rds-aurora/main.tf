provider "aws" {
  region = "us-east-1"
}

locals {
  identifier = "aws-rds-aurora"
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

resource "aws_security_group" "rds" {
  name   = "${local.identifier}-rds"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "rds_ingress_all" {
  from_port   = 0
  protocol    = "-1"
  security_group_id = aws_security_group.rds.id
  source_security_group_id = aws_security_group.rds.id
  to_port     = 0
  type        = "ingress"
}

resource "aws_security_group_rule" "rds_ingress_postgres" {
  from_port   = 5432
  protocol    = "tcp"
  security_group_id = aws_security_group.rds.id
  source_security_group_id = aws_security_group.ec2.id
  to_port     = 5432
  type        = "ingress"
}

resource "aws_security_group_rule" "rds_egress" {
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 0
  protocol    = "-1"
  security_group_id = aws_security_group.rds.id
  to_port     = 0
  type        = "egress"
}

resource "aws_db_subnet_group" "this" {
  name       = local.identifier
  subnet_ids = data.aws_subnet_ids.this.ids
}

resource "aws_rds_cluster" "this" {
  backup_retention_period         = 7
  copy_tags_to_snapshot           = true
  cluster_identifier              = local.identifier
  database_name                   = "hellords"
  db_subnet_group_name            = aws_db_subnet_group.this.name 
  db_cluster_parameter_group_name = "default.aurora-postgresql10"
  engine                          = "aurora-postgresql"
  # engine_version
  master_username                 = var.username
  master_password                 = var.password
  port                            = 5432
  skip_final_snapshot             = true
  vpc_security_group_ids          = [aws_security_group.rds.id]
}

resource "aws_rds_cluster_instance" "this" {
  cluster_identifier           = aws_rds_cluster.this.id
  count                        = 2
  db_parameter_group_name      = "default.aurora-postgresql10"
  db_subnet_group_name         = aws_db_subnet_group.this.name 
  engine                       = "aurora-postgresql"
  # engine_version
  identifier                   = "aurora-cluster-demo-${count.index}"
  instance_class               = "db.t3.medium"
  performance_insights_enabled = true
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
