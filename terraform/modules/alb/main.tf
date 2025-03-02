terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_security_group" "main" {
  name        = "${var.name}-sg"
  vpc_id      = data.aws_vpc.main.id
  description = "SG for ${var.name}"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "${var.name}-sg"
  }
}

# Application Load Balancer
resource "aws_lb" "this" {
  name                             = var.name
  internal                         = false
  load_balancer_type               = "application"
  desync_mitigation_mode           = "defensive"
  drop_invalid_header_fields       = true
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
  enable_http2                     = true
  idle_timeout                     = 60
  ip_address_type                  = "ipv4"

  security_groups = [aws_security_group.main.id]
  subnets         = data.aws_subnets.main.ids
}

# HTTPS Listener
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
  mutual_authentication {
    mode            = "verify"
    trust_store_arn = var.trust_store_arn
  }
}
