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

variable "environment" {
  type        = string
  description = "The name of the environment"
}

# ------------------------------------------------------------------------------
# CIC ASG Variables
# ------------------------------------------------------------------------------

variable "cic_instance_size" {
  type        = string
  description = "The size of the ec2 instances to build"
}

variable "cic_min_size" {
  type        = number
  description = "The min size of the ASG"
}

variable "cic_max_size" {
  type        = number
  description = "The max size of the ASG"
}

variable "cic_desired_capacity" {
  type        = number
  description = "The desired capacity of ASG"
}

variable "cic_ami_name" {
  type        = string
  default     = "docker-ami-*"
  description = "Name of the AMI to use in the Auto Scaling configuration for CICs"
}


# ------------------------------------------------------------------------------
# CIC ALB Variables
# ------------------------------------------------------------------------------

variable "cic_application_port" {
  type        = number
  default     = 21000
  description = "Target group backend port"
}

variable "cic_health_check_path" {
  type        = string
  default     = "/"
  description = "Target group health check path"
}

variable "domain_name" {
  type        = string
  default     = "*.companieshouse.gov.uk"
  description = "Domain Name for ACM Certificate"
}