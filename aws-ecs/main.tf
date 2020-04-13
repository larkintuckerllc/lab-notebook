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
