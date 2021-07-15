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
