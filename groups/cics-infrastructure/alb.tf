module "cics_internal_alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "sgr-${var.application}-internal-alb-001"
  description = "Security group for the ${var.application} servers"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_cidr_blocks = local.admin_cidrs
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  egress_rules        = ["all-all"]
}

resource "aws_lb" "cics" {
  name               = "alb-${var.application}-internal-001"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [module.cics_internal_alb_security_group.this_security_group_id]
  subnets            = data.aws_subnet_ids.application.ids //Change to just single subnet possibly

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "cics_app_1" {
  name                  = "tg-${var.application}-app-internal-001"
  vpc_id                = data.aws_vpc.vpc.id
  port                  = var.cics_application_port
  protocol              = "HTTP"
  target_type           = "instance"
  deregistration_delay  = 10
  health_check {
    enabled             = true
    interval            = 30
    path                = var.cics_health_check_path
    port                = var.cics_application_port
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
    protocol            = "HTTP"
    matcher             = "200-399"
  }
}

resource "aws_lb_target_group" "cics_app_2" {
  name                  = "tg-${var.application}-app-internal-002"
  vpc_id                = data.aws_vpc.vpc.id
  port                  = var.cics_application_port
  protocol              = "HTTP"
  target_type           = "instance"
  deregistration_delay  = 10
  health_check {
    enabled             = true
    interval            = 30
    path                = var.cics_health_check_path
    port                = var.cics_application_port
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
    protocol            = "HTTP"
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "cics_http" {
  load_balancer_arn = aws_lb.cics.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type              = "redirect"
    redirect {
      port              = "443"
      protocol          = "HTTPS"
      status_code       = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "cics_https" {
  load_balancer_arn = aws_lb.cics.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.acm_cert.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      status_code  = "503"
      content_type = "text/plain"
    }
  }
}

resource "aws_lb_listener_rule" "cics_app_host_based_routing" {
  listener_arn = aws_lb_listener.cics_https.arn
  priority     = 99

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.cics_app_1.arn
        weight = 50
      }

      target_group {
        arn    = aws_lb_target_group.cics_app_2.arn
        weight = 50
      }

      stickiness {
        enabled  = true
        duration = 3600
      }
    }
  }

  condition {
    host_header {
      values = ["cics.*"]
    }
  }
}