provider "aws" {
  region = "us-east-1"
}

locals {
  identifier = "aws-xray"
}

data "aws_region" "this" {}

data "aws_subnet_ids" "this" {
  vpc_id = var.vpc_id
}

data "aws_acm_certificate" "this" {
  domain  = var.certificate
}

data "aws_route53_zone" "this" {
  name = "${var.zone_name}."
}

data "aws_ecr_repository" "this" {
  name = var.repository
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

# IAM ROLES

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

# VPC SECURITY GROUPS

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

# EC2 Load Balancer

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

resource "aws_lb" "this" {
  load_balancer_type = "application"
  name               = local.identifier
  security_groups    = [aws_security_group.lb.id]
  subnets            = data.aws_subnet_ids.this.ids
}

resource "aws_lb_listener" "this" {
  certificate_arn    = data.aws_acm_certificate.this.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
  load_balancer_arn  = aws_lb.this.arn
  port               = "443"
  protocol           = "HTTPS"
  ssl_policy         = "ELBSecurityPolicy-2016-08"
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.id
  name    = "${local.identifier}.todosrus.com"
  type    = "A"
  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = false
  }
}

# ECS

resource "aws_ecs_cluster" "this" {
  name = local.identifier
}

resource "aws_ecs_task_definition" "this" {
    container_definitions    = <<EOF
[
  {
    "cpu": 256,
    "environment": [
      {
        "name": "REGION",
        "value": "${data.aws_region.this.name}"
      }
    ],
    "essential": true,
    "image": "${data.aws_ecr_repository.this.repository_url}",
    "memory": 512,
    "mountPoints": [],
    "name": "${local.identifier}",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80,
        "protocol": "tcp"
      }
    ],
    "volumesFrom": []
  }   
]
EOF
    cpu                      = 256
    execution_role_arn       = aws_iam_role.execution.arn
    family                   = local.identifier
    memory                   = 512
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    task_role_arn            = aws_iam_role.task.arn
}

resource "aws_ecs_service" "this" {
    cluster               = aws_ecs_cluster.this.id
    depends_on            = [aws_lb_listener.this]
    desired_count         = 1
    launch_type           = "FARGATE"
    load_balancer {
      target_group_arn = aws_lb_target_group.this.arn
      container_name   = local.identifier
      container_port   = 80
    }
    name                  = local.identifier
    network_configuration {
      assign_public_ip    = true
      security_groups     = [aws_security_group.web.id]
      subnets             = data.aws_subnet_ids.this.ids
    }
    task_definition       = aws_ecs_task_definition.this.arn
}
