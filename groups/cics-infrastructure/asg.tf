# ------------------------------------------------------------------------------
# CIC Security Group and rules
# ------------------------------------------------------------------------------
module "cic_asg_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "sgr-${var.application}-asg-001"
  description = "Security group for the ${var.application} asg"
  vpc_id      = data.aws_vpc.vpc.id

  egress_rules = ["all-all"]
}

# ASG Module for cic1
module "cic1_asg" {
  source = "git@github.com:companieshouse/terraform-modules/aws/terraform-aws-autoscaling?ref=tags/1.0.36"

  name = "${var.application}-cic1"
  # Launch configuration
  lc_name       = "${var.application}-cic-launchconfig"
  image_id      = data.aws_ami.cic.id
  instance_type = var.cic_instance_size
  security_groups = [
    module.cic_asg_security_group.this_security_group_id,
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
  asg_name                       = "${var.application}-cic1-asg"
  vpc_zone_identifier            = data.aws_subnet_ids.application.ids
  health_check_type              = "EC2"
  min_size                       = var.cic_min_size
  max_size                       = var.cic_max_size
  desired_capacity               = var.cic_desired_capacity
  health_check_grace_period      = 300
  wait_for_capacity_timeout      = 0
  force_delete                   = true
  enable_instance_refresh        = true
  refresh_min_healthy_percentage = 50
  refresh_triggers               = ["launch_configuration"]
  key_name                       = aws_key_pair.cic_keypair.key_name
  termination_policies           = ["OldestLaunchConfiguration"]
  //iam_instance_profile           = module.cic_profile.aws_iam_instance_profile.name
  user_data_base64               = data.template_cloudinit_config.cic_userdata_config.rendered

  tags_as_map = merge(
    local.default_tags,
    map(
      "app-instance-name", "cic1",
      "config-base-path", "configbucket-todo"
    )
  )
}

# ASG Module for cic2
module "cic2_asg" {
  source = "git@github.com:companieshouse/terraform-modules/aws/terraform-aws-autoscaling?ref=tags/1.0.36"

  name = "${var.application}-cic2"
  # Launch configuration
  lc_name       = "${var.application}-cic-launchconfig"
  image_id      = data.aws_ami.cic.id
  instance_type = var.cic_instance_size
  security_groups = [
    module.cic_asg_security_group.this_security_group_id,
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
  asg_name                       = "${var.application}-cic2-asg"
  vpc_zone_identifier            = data.aws_subnet_ids.application.ids
  health_check_type              = "EC2"
  min_size                       = var.cic_min_size
  max_size                       = var.cic_max_size
  desired_capacity               = var.cic_desired_capacity
  health_check_grace_period      = 300
  wait_for_capacity_timeout      = 0
  force_delete                   = true
  enable_instance_refresh        = true
  refresh_min_healthy_percentage = 50
  refresh_triggers               = ["launch_configuration"]
  key_name                       = aws_key_pair.cic_keypair.key_name
  termination_policies           = ["OldestLaunchConfiguration"]
  //iam_instance_profile           = module.cic_profile.aws_iam_instance_profile.name
  user_data_base64               = data.template_cloudinit_config.cic_userdata_config.rendered

  tags_as_map = merge(
    local.default_tags,
    map(
      "app-instance-name", "cic2",
      "config-base-path", "configbucket-todo"
    )
  )
}