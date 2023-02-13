data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  tags = {
    Name = "vpc-${var.aws_account}"
  }
}

data "aws_subnet_ids" "application" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-application-*"]
  }
}

data "aws_security_group" "nagios_shared" {
  filter {
    name   = "group-name"
    values = ["sgr-nagios-inbound-shared-*"]
  }
}

data "aws_security_group" "chips_control" {
  filter {
    name   = "group-name"
    values = ["sgr-chips-control-asg-001-*"]
  }
}

data "aws_route53_zone" "private_zone" {
  name         = local.internal_fqdn
  private_zone = true
}

data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "vault_generic_secret" "internal_cidrs" {
  path = "aws-accounts/network/internal_cidr_ranges"
}

data "vault_generic_secret" "cics_ec2_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/ec2"
}

data "aws_acm_certificate" "acm_cert" {
  domain = var.domain_name
}

data "vault_generic_secret" "kms_keys" {
  path = "aws-accounts/${var.aws_account}/kms"
}

data "vault_generic_secret" "security_kms_keys" {
  path = "aws-accounts/security/kms"
}

data "vault_generic_secret" "security_s3_buckets" {
  path = "aws-accounts/security/s3"
}

data "aws_ami" "cics" {
  owners      = [data.vault_generic_secret.account_ids.data["development"]]
  most_recent = var.cics_ami_name == "docker-ami-*" ? true : false

  filter {
    name = "name"
    values = [
      var.cics_ami_name,
    ]
  }

  filter {
    name = "state"
    values = [
      "available",
    ]
  }
}

data "template_file" "cics_userdata" {
  template = file("${path.module}/templates/cics_user_data.tpl")
  vars = {
    REGION               = var.aws_region
    HERITAGE_ENVIRONMENT = title(var.environment)
    ANSIBLE_INPUTS = jsonencode(local.userdata_ansible_inputs)
  }
}

data "template_cloudinit_config" "cics_userdata_config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.cics_userdata.rendered
  }

}
