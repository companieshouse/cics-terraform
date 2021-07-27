# ------------------------------------------------------------------------------
# CIC Security Group and rules
# ------------------------------------------------------------------------------
module "cics_asg_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "sgr-${var.application}-asg-001"
  description = "Security group for the ${var.application} asg"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_cidr_blocks = local.admin_cidrs
  ingress_rules       = ["ssh-tcp"]

  ingress_with_source_security_group_id = [
    {
      from_port                = var.cics_application_port
      to_port                  = var.cics_application_port
      protocol                 = "tcp"
      description              = "Apache port"
      source_security_group_id = module.cics_internal_alb_security_group.this_security_group_id
    },
    {
      from_port                = var.cics_admin_port
      to_port                  = var.cics_admin_port
      protocol                 = "tcp"
      description              = "WebLogic administration console port"
      source_security_group_id = module.cics_internal_alb_security_group.this_security_group_id
    }
  ]

  egress_rules = ["all-all"]
}

# ASG Module for cics1
module "cics1_asg" {
  source = "git@github.com:companieshouse/terraform-modules//aws/terraform-aws-autoscaling?ref=tags/1.0.36"

  name = "${var.application}1"
  # Launch configuration
  lc_name       = "${var.application}1-launchconfig"
  image_id      = data.aws_ami.cics.id
  instance_type = var.cics_instance_size
  security_groups = [
    module.cics_asg_security_group.this_security_group_id,
    data.aws_security_group.nagios_shared.id
  ]
  root_block_device = [
    {
      volume_size = "40"
      volume_type = "gp2"
      encrypted   = true
      iops        = 0
    },
  ]
  # Auto scaling group
  asg_name                       = "${var.application}1-asg"
  vpc_zone_identifier            = data.aws_subnet_ids.application.ids
  health_check_type              = "EC2"
  min_size                       = var.cics_min_size
  max_size                       = var.cics_max_size
  desired_capacity               = var.cics_desired_capacity
  health_check_grace_period      = 300
  wait_for_capacity_timeout      = 0
  force_delete                   = true
  enable_instance_refresh        = true
  refresh_min_healthy_percentage = 50
  refresh_triggers               = ["launch_configuration"]
  key_name                       = aws_key_pair.cics_keypair.key_name
  termination_policies           = ["OldestLaunchConfiguration"]
  target_group_arns = [
    aws_lb_target_group.cics_app[0].arn,
    aws_lb_target_group.cics_app[1].arn,
    aws_lb_target_group.cics_admin[0].arn
  ]
  iam_instance_profile = module.cics_profile.aws_iam_instance_profile.name
  user_data_base64     = data.template_cloudinit_config.cics_userdata_config.rendered

  tags_as_map = merge(
    local.default_tags,
    tomap({
      app-instance-name = "${var.application}1"
      config-base-path  = "s3://shared-services.eu-west-2.configs.ch.gov.uk/cic-configs/${var.environment}"
    })
  )
}

# ASG Module for cics2
module "cics2_asg" {
  source = "git@github.com:companieshouse/terraform-modules//aws/terraform-aws-autoscaling?ref=tags/1.0.36"

  count = var.cics_asg_count > 1 ? 1 : 0
  name  = "${var.application}2"
  # Launch configuration
  lc_name       = "${var.application}2-launchconfig"
  image_id      = data.aws_ami.cics.id
  instance_type = var.cics_instance_size
  security_groups = [
    module.cics_asg_security_group.this_security_group_id,
    data.aws_security_group.nagios_shared.id
  ]
  root_block_device = [
    {
      volume_size = "40"
      volume_type = "gp2"
      encrypted   = true
      iops        = 0
    },
  ]
  # Auto scaling group
  asg_name                       = "${var.application}2-asg"
  vpc_zone_identifier            = data.aws_subnet_ids.application.ids
  health_check_type              = "EC2"
  min_size                       = var.cics_min_size
  max_size                       = var.cics_max_size
  desired_capacity               = var.cics_desired_capacity
  health_check_grace_period      = 300
  wait_for_capacity_timeout      = 0
  force_delete                   = true
  enable_instance_refresh        = true
  refresh_min_healthy_percentage = 50
  refresh_triggers               = ["launch_configuration"]
  key_name                       = aws_key_pair.cics_keypair.key_name
  termination_policies           = ["OldestLaunchConfiguration"]
  target_group_arns = [
    aws_lb_target_group.cics_app[0].arn,
    aws_lb_target_group.cics_app[2].arn,
    aws_lb_target_group.cics_admin[1].arn
  ]
  iam_instance_profile = module.cics_profile.aws_iam_instance_profile.name
  user_data_base64     = data.template_cloudinit_config.cics_userdata_config.rendered

  tags_as_map = merge(
    local.default_tags,
    tomap({
      app-instance-name = "${var.application}2"
      config-base-path  = "s3://shared-services.eu-west-2.configs.ch.gov.uk/cic-configs/${var.environment}"
    })
  )
}

resource "aws_cloudwatch_log_group" "cics_log_groups" {
  for_each = local.cloudwatch_logs

  name              = each.value["log_group_name"]
  retention_in_days = lookup(each.value, "log_group_retention", var.default_log_group_retention_in_days)
  kms_key_id        = lookup(each.value, "kms_key_id", local.logs_kms_key_id)
}
