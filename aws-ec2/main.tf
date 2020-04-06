provider "aws" {
  region = "us-east-1"
}

data "aws_subnet_ids" "this" {
  vpc_id = var.vpc_id
}

data "aws_acm_certificate" "this" {
  domain  = "aws-ec2.todosrus.com"
}

data "aws_route53_zone" "this" {
  name = "todosrus.com."
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

resource "aws_lb" "this" {
  internal           = false
  load_balancer_type = "application"
  name               = "aws-ec2"
  security_groups    = [aws_security_group.this.id]
  subnets            = data.aws_subnet_ids.this.ids
}

resource "aws_lb_target_group" "this" {
  health_check {
    path = "/" 
  }
  name        = "aws-ec2"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
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
  name    = "aws-ec2.todosrus.com"
  type    = "A"
  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = false
  }
}
