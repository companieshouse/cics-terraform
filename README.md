# cics-terraform
Infrastructure code for CICs application

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3, < 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0, < 6.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 4.0, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0, < 6.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 4.0, < 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cics1_asg"></a> [cics1\_asg](#module\_cics1\_asg) | git@github.com:companieshouse/terraform-modules//aws/autoscaling-with-launch-template | tags/1.0.361 |
| <a name="module_cics2_asg"></a> [cics2\_asg](#module\_cics2\_asg) | git@github.com:companieshouse/terraform-modules//aws/autoscaling-with-launch-template | tags/1.0.361 |
| <a name="module_cics_asg_security_group"></a> [cics\_asg\_security\_group](#module\_cics\_asg\_security\_group) | terraform-aws-modules/security-group/aws | ~> 5.0 |
| <a name="module_cics_internal_alb_security_group"></a> [cics\_internal\_alb\_security\_group](#module\_cics\_internal\_alb\_security\_group) | terraform-aws-modules/security-group/aws | ~> 5.0 |
| <a name="module_cics_profile"></a> [cics\_profile](#module\_cics\_profile) | git@github.com:companieshouse/terraform-modules//aws/instance_profile | tags/1.0.361 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_schedule.cics-schedule-start-cics1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_autoscaling_schedule.cics-schedule-start-cics2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_autoscaling_schedule.cics-schedule-stop-cics1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_autoscaling_schedule.cics-schedule-stop-cics2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_cloudwatch_log_group.cics_log_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role_policy_attachment.inspector_cis_scanning_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_key_pair.cics_keypair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_lb.cics](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.cics_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.cics_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.cics_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.cics_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.cics_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.cics_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route53_record.cics_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.cics_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_acm_certificate.acm_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_ami.cics](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_route53_zone.private_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_security_group.chips_control](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_security_group.nagios_shared](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnets.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [template_cloudinit_config.cics_userdata_config](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config) | data source |
| [template_file.cics_userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [vault_generic_secret.account_ids](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.cics_ec2_data](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.internal_cidrs](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.kms_keys](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.nfs_mounts](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_kms_keys](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_s3_buckets](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | Short version of the name of the AWS Account in which resources will be administered | `string` | n/a | yes |
| <a name="input_application"></a> [application](#input\_application) | The name of the application | `string` | n/a | yes |
| <a name="input_application_type"></a> [application\_type](#input\_application\_type) | The parent name of the application | `string` | `"cics"` | no |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | The name of the AWS Account in which resources will be administered | `string` | n/a | yes |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | The AWS profile to use | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_cics_admin_health_check_path"></a> [cics\_admin\_health\_check\_path](#input\_cics\_admin\_health\_check\_path) | Target group health check path for administration console | `string` | `"/console"` | no |
| <a name="input_cics_admin_port"></a> [cics\_admin\_port](#input\_cics\_admin\_port) | Target group backend port for administration | `number` | `21001` | no |
| <a name="input_cics_ami_name"></a> [cics\_ami\_name](#input\_cics\_ami\_name) | Name of the AMI to use in the Auto Scaling configuration for CICs | `string` | `"docker-ami-*"` | no |
| <a name="input_cics_app_health_check_path"></a> [cics\_app\_health\_check\_path](#input\_cics\_app\_health\_check\_path) | Target group health check path for application | `string` | `"/"` | no |
| <a name="input_cics_application_port"></a> [cics\_application\_port](#input\_cics\_application\_port) | Target group backend port for application | `number` | `21000` | no |
| <a name="input_cics_asg_count"></a> [cics\_asg\_count](#input\_cics\_asg\_count) | The number of ASGs - typically 1 for dev and 2 for staging/live | `number` | n/a | yes |
| <a name="input_cics_desired_capacity"></a> [cics\_desired\_capacity](#input\_cics\_desired\_capacity) | The desired capacity of ASG - always 1 | `number` | `1` | no |
| <a name="input_cics_instance_size"></a> [cics\_instance\_size](#input\_cics\_instance\_size) | The size of the ec2 instances to build | `string` | n/a | yes |
| <a name="input_cics_max_size"></a> [cics\_max\_size](#input\_cics\_max\_size) | The max size of the ASG - always 1 | `number` | `1` | no |
| <a name="input_cics_min_size"></a> [cics\_min\_size](#input\_cics\_min\_size) | The min size of the ASG - always 1 | `number` | `1` | no |
| <a name="input_cloudwatch_logs"></a> [cloudwatch\_logs](#input\_cloudwatch\_logs) | Map of log file information; used to create log groups, IAM permissions and passed to the application to configure remote logging | `map(any)` | `{}` | no |
| <a name="input_default_log_group_retention_in_days"></a> [default\_log\_group\_retention\_in\_days](#input\_default\_log\_group\_retention\_in\_days) | Total days to retain logs in CloudWatch log group if not specified for specific logs | `number` | `14` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain Name for ACM Certificate | `string` | `"*.companieshouse.gov.uk"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_hashicorp_vault_password"></a> [hashicorp\_vault\_password](#input\_hashicorp\_vault\_password) | The password used when retrieving configuration from Hashicorp Vault | `string` | n/a | yes |
| <a name="input_hashicorp_vault_username"></a> [hashicorp\_vault\_username](#input\_hashicorp\_vault\_username) | The username used when retrieving configuration from Hashicorp Vault | `string` | n/a | yes |
| <a name="input_instance_root_volume_size"></a> [instance\_root\_volume\_size](#input\_instance\_root\_volume\_size) | Size of root volume attached to instances | `number` | `40` | no |
| <a name="input_instance_swap_volume_size"></a> [instance\_swap\_volume\_size](#input\_instance\_swap\_volume\_size) | Size of swap volume attached to instances | `number` | `5` | no |
| <a name="input_nfs_mount_destination_parent_dir"></a> [nfs\_mount\_destination\_parent\_dir](#input\_nfs\_mount\_destination\_parent\_dir) | The parent folder that all NFS shares should be mounted inside on the EC2 instance | `string` | `"/mnt/nfs"` | no |
| <a name="input_region"></a> [region](#input\_region) | Short version of the name of the AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_vault_password"></a> [vault\_password](#input\_vault\_password) | Password for connecting to Vault - usually supplied through TF\_VARS | `string` | n/a | yes |
| <a name="input_vault_username"></a> [vault\_username](#input\_vault\_username) | Username for connecting to Vault - usually supplied through TF\_VARS | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cics_admin_1_address_internal"></a> [cics\_admin\_1\_address\_internal](#output\_cics\_admin\_1\_address\_internal) | n/a |
| <a name="output_cics_admin_2_address_internal"></a> [cics\_admin\_2\_address\_internal](#output\_cics\_admin\_2\_address\_internal) | n/a |
| <a name="output_cics_app_address_internal"></a> [cics\_app\_address\_internal](#output\_cics\_app\_address\_internal) | n/a |
<!-- END_TF_DOCS -->
