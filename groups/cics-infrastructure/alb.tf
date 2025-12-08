module "cics_internal_alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "sgr-${var.application}-internal-alb-001"
  description = "Security group for the ${var.application} servers"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_cidr_blocks = local.admin_cidrs
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]

  ingress_with_source_security_group_id = [
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      description              = "HTTPS from chips-control"
      source_security_group_id = data.aws_security_group.chips_control.id
    }
  ]

  egress_rules        = ["all-all"]

  tags = merge(
    local.default_tags,
    {
      Name = "sgr-${var.application}-internal-alb-001"
    }
  )
}

resource "aws_lb" "cics" {
  name               = "alb-${var.application}-internal-001"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [module.cics_internal_alb_security_group.security_group_id]
  subnets            = data.aws_subnets.application.ids

  enable_deletion_protection = true

  access_logs {
    bucket  = local.elb_access_logs_bucket_name
    prefix  = local.elb_access_logs_prefix
    enabled = true
  }

  tags = merge(
    local.default_tags,
    {
      Name = "alb-${var.application}-internal-001"
    }
  )
}

resource "aws_lb_target_group" "cics_app" {
  count                = var.cics_asg_count + 1
  name                 = "tg-${var.application}-app-internal-00${count.index}"
  vpc_id               = data.aws_vpc.vpc.id
  port                 = var.cics_application_port
  protocol             = "HTTP"
  target_type          = "instance"
  deregistration_delay = 10

  health_check {
    enabled             = true
    interval            = 30
    path                = var.cics_app_health_check_path
    port                = var.cics_application_port
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
    protocol            = "HTTP"
    matcher             = "200-399"
  }

  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 86400
  }
}

resource "aws_lb_target_group" "cics_admin" {
  count                = var.cics_asg_count
  name                 = "tg-${var.application}-admin-internal-00${count.index + 1}"
  vpc_id               = data.aws_vpc.vpc.id
  port                 = var.cics_admin_port
  protocol             = "HTTP"
  target_type          = "instance"
  deregistration_delay = 10
  health_check {
    enabled             = true
    interval            = 30
    path                = var.cics_admin_health_check_path
    port                = var.cics_admin_port
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
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "cics_https" {
  load_balancer_arn = aws_lb.cics.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08" #tfsec:ignore:AWS010
  certificate_arn   = data.aws_acm_certificate.acm_cert.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      status_code  = "503"
      content_type = "text/plain"
    }
  }
}

resource "aws_lb_listener_rule" "cics_app" {
  listener_arn = aws_lb_listener.cics_https.arn
  priority     = 10

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.cics_app[0].arn
        weight = 100
      }

      target_group {
        arn    = aws_lb_target_group.cics_app[1].arn
        weight = 0
      }

      dynamic "target_group" {
        for_each = var.cics_asg_count > 1 ? [1] : []
        content {
          arn    = aws_lb_target_group.cics_app[2].arn
          weight = 0
        }
      }

      stickiness {
        enabled  = true
        duration = 86400
      }
    }
  }

  condition {
    host_header {
      values = ["cics.*"]
    }
  }
}

resource "aws_lb_listener_rule" "cics_admin" {
  count        = var.cics_asg_count
  listener_arn = aws_lb_listener.cics_https.arn
  priority     = 20 + count.index

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cics_admin[count.index].arn
  }

  condition {
    host_header {
      values = ["cics-admin-${count.index + 1}.*"]
    }
  }
}
