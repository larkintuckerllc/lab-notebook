provider "aws" {
  region = "us-east-1"
}

locals {
  identifier = "aws-efs"
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

resource "aws_security_group_rule" "this_ingress_http" {
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 80
  protocol    = "tcp"
  security_group_id = aws_security_group.this.id
  to_port     = 80
  type        = "ingress"
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

resource "aws_lb_target_group" "this" {
  health_check {
    path = "/" 
  }
  name        = local.identifier
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}

resource "aws_lb" "this" {
  internal           = false
  load_balancer_type = "application"
  name               = local.identifier
  security_groups    = [aws_security_group.this.id]
  subnets            = data.aws_subnet_ids.this.ids
}

resource "aws_lb_listener" "https" {
  certificate_arn    = data.aws_acm_certificate.this.arn
  default_action {
    target_group_arn = aws_lb_target_group.this.arn
    type             = "forward"
  }
  load_balancer_arn  = aws_lb.this.arn
  port               = "443"
  protocol           = "HTTPS"
  ssl_policy         = "ELBSecurityPolicy-2016-08"
}

resource "aws_lb_listener" "http" {
  default_action {
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
    type = "redirect"
  }
  load_balancer_arn  = aws_lb.this.arn
  port               = "80"
  protocol           = "HTTP"
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.id
  name    = "${local.identifier}.${var.zone_name}"
  type    = "A"
  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = false
  }
}

resource "aws_launch_template" "this" {
  image_id               = data.aws_ami.this.id
  instance_type          = "t3.micro"
  user_data              = filebase64("user-data.sh")
  key_name               = var.key_name
  name                   = local.identifier
  vpc_security_group_ids = [aws_security_group.this.id]
}

resource "aws_autoscaling_group" "this" {
  desired_capacity    = 1 
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
  max_size            = 1
  min_size            = 1
  name_prefix         = "${local.identifier}-${aws_launch_template.this.latest_version}-"
  target_group_arns   = [aws_lb_target_group.this.arn]
  vpc_zone_identifier = data.aws_subnet_ids.this.ids
}
