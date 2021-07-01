output "cics_app_address_internal" {
  value = aws_route53_record.cics_alb_internal.fqdn
}