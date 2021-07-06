resource "aws_route53_record" "cics_app" {
  zone_id = data.aws_route53_zone.private_zone.zone_id
  name    = var.application
  type    = "A"

  alias {
    name                   = aws_lb.cics.dns_name
    zone_id                = aws_lb.cics.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cics_admin_1" {
  zone_id = data.aws_route53_zone.private_zone.zone_id
  name    = "${var.application}-admin-1"
  type    = "A"

  alias {
    name                   = aws_lb.cics.dns_name
    zone_id                = aws_lb.cics.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cics_admin_2" {
  zone_id = data.aws_route53_zone.private_zone.zone_id
  name    = "${var.application}-admin-2"
  type    = "A"

  alias {
    name                   = aws_lb.cics.dns_name
    zone_id                = aws_lb.cics.zone_id
    evaluate_target_health = true
  }
}