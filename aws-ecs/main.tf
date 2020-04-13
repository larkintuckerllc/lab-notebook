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
