output "cics_app_address_internal" {
  value = aws_route53_record.cics_app.fqdn
}

output "cics_admin_1_address_internal" {
  value = length(aws_route53_record.cics_admin) > 0 ? aws_route53_record.cics_admin[0].fqdn : null
}

output "cics_admin_2_address_internal" {
  value = length(aws_route53_record.cics_admin) > 1 ? aws_route53_record.cics_admin[1].fqdn : null
}
