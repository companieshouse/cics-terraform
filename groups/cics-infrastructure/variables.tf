# ------------------------------------------------------------------------------
# Vault Variables
# ------------------------------------------------------------------------------
variable "vault_username" {
  type        = string
  description = "Username for connecting to Vault - usually supplied through TF_VARS"
}

variable "vault_password" {
  type        = string
  description = "Password for connecting to Vault - usually supplied through TF_VARS"
}

# ------------------------------------------------------------------------------
# AWS Variables
# ------------------------------------------------------------------------------
variable "aws_region" {
  type        = string
  description = "The AWS region in which resources will be administered"
}

variable "aws_profile" {
  type        = string
  description = "The AWS profile to use"
}

variable "aws_account" {
  type        = string
  description = "The name of the AWS Account in which resources will be administered"
}

# ------------------------------------------------------------------------------
# AWS Variables - Shorthand
# ------------------------------------------------------------------------------

variable "account" {
  type        = string
  description = "Short version of the name of the AWS Account in which resources will be administered"
}

variable "region" {
  type        = string
  description = "Short version of the name of the AWS region in which resources will be administered"
}

# ------------------------------------------------------------------------------
# Environment Variables
# ------------------------------------------------------------------------------

variable "application" {
  type        = string
  description = "The name of the application"
}

variable "application_type" {
  type        = string
  default     = "cics"
  description = "The parent name of the application"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}

# ------------------------------------------------------------------------------
# CIC ASG Variables
# ------------------------------------------------------------------------------

variable "cics_instance_size" {
  type        = string
  description = "The size of the ec2 instances to build"
}

variable "cics_min_size" {
  type        = number
  default     = 1
  description = "The min size of the ASG - always 1"
}

variable "cics_max_size" {
  type        = number
  default     = 1
  description = "The max size of the ASG - always 1"
}

variable "cics_desired_capacity" {
  type        = number
  default     = 1
  description = "The desired capacity of ASG - always 1"
}

variable "cics_asg_count" {
  type        = number
  description = "The number of ASGs - typically 1 for dev and 2 for staging/live"
}

variable "cics_ami_name" {
  type        = string
  default     = "docker-ami-*"
  description = "Name of the AMI to use in the Auto Scaling configuration for CICs"
}

variable "instance_root_volume_size" {
  type        = number
  default     = 40
  description = "Size of root volume attached to instances"
}

variable "instance_swap_volume_size" {
  type        = number
  default     = 5
  description = "Size of swap volume attached to instances"
}

# ------------------------------------------------------------------------------
# CIC ALB Variables
# ------------------------------------------------------------------------------

variable "cics_application_port" {
  type        = number
  default     = 21000
  description = "Target group backend port for application"
}

variable "cics_admin_port" {
  type        = number
  default     = 21001
  description = "Target group backend port for administration"
}

variable "cics_app_health_check_path" {
  type        = string
  default     = "/"
  description = "Target group health check path for application"
}

variable "cics_admin_health_check_path" {
  type        = string
  default     = "/console"
  description = "Target group health check path for administration console"
}

variable "domain_name" {
  type        = string
  default     = "*.companieshouse.gov.uk"
  description = "Domain Name for ACM Certificate"
}

variable "nfs_mount_destination_parent_dir" {
  type        = string
  description = "The parent folder that all NFS shares should be mounted inside on the EC2 instance"
  default     = "/mnt/nfs"
}

variable "default_log_group_retention_in_days" {
  type        = number
  default     = 14
  description = "Total days to retain logs in CloudWatch log group if not specified for specific logs"
}

variable "cloudwatch_logs" {
  type        = map(any)
  description = "Map of log file information; used to create log groups, IAM permissions and passed to the application to configure remote logging"
  default     = {}
}
