output "cic_app_address_internal" {
  value = aws_route53_record.cic_alb_internal.fqdn
}