locals {
  admin_cidrs  = values(data.vault_generic_secret.internal_cidrs.data)
  cic_ec2_data = data.vault_generic_secret.cic_ec2_data.data

  internal_fqdn = format("%s.%s.aws.internal", split("-", var.aws_account)[1], split("-", var.aws_account)[0])

  default_tags = {
    Terraform   = "true"
    Application = upper(var.application)
    Region      = var.aws_region
    Account     = var.aws_account
  }
}