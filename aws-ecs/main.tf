provider "aws" {
  region = "us-east-1"
}

locals {
  identifier = "aws-ecs"
}

data "aws_subnet_ids" "this" {
  vpc_id = var.vpc_id
}

data "aws_acm_certificate" "this" {
  domain  = var.certificate
}

data "aws_route53_zone" "this" {
  name = "${var.zone_name}."
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

data "aws_ecr_repository" "this" {
  name = local.identifier
}

resource "aws_iam_role" "execution" {
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  name               = "${local.identifier}-execution"
}

resource "aws_iam_role_policy_attachment" "execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.execution.name
}

resource "aws_iam_role" "task" {
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  name               = "${local.identifier}-task"
}

resource "aws_iam_role_policy" "task" {
    name   = "DynamoDBWriteTodos"
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
            "Resource": "arn:aws:dynamodb:us-east-1:143287522423:table/Todos"
        }
    ]
}
EOF
    role   = aws_iam_role.task.id
}

resource "aws_security_group" "lb" {
  name   = "${local.identifier}.lb"
  vpc_id = var.vpc_id
}

resource "aws_security_group" "web" {
  name   = "${local.identifier}.web"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "lb_ingress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.lb.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "lb_egress" {
  from_port                = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.lb.id
  source_security_group_id = aws_security_group.web.id
  to_port                  = 80
  type                     = "egress"
}

resource "aws_security_group_rule" "web_ingress" {
  from_port                = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web.id
  source_security_group_id = aws_security_group.lb.id
  to_port                  = 80
  type                     = "ingress"
}

resource "aws_security_group_rule" "web_egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.web.id
  to_port           = 0
  type              = "egress"
}

resource "aws_lb" "this" {
  load_balancer_type = "application"
  name               = local.identifier
  security_groups    = [aws_security_group.lb.id]
  subnets            = data.aws_subnet_ids.this.ids
}

resource "aws_lb_target_group" "this" {
  health_check {
    path = "/hc"
  }
  name        = local.identifier
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}
