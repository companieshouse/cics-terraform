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

resource "aws_route53_record" "cics_admin" {
  count   = var.cics_asg_count
  zone_id = data.aws_route53_zone.private_zone.zone_id
  name    = "${var.application}-admin-${count.index + 1}"
  type    = "A"

  alias {
    name                   = aws_lb.cics.dns_name
    zone_id                = aws_lb.cics.zone_id
    evaluate_target_health = true
  }
}
