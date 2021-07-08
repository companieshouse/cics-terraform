module "cics_profile" {
  source = "git@github.com:companieshouse/terraform-modules//aws/instance_profile?ref=tags/1.0.59"

  name       = "cics-profile"
  enable_SSM = true

  s3_buckets_write  = [local.session_manager_bucket_name]

  kms_key_refs = [
    "alias/${var.account}/${var.region}/ebs",
    local.ssm_kms_key_id
  ]

  custom_statements = [
    {
      sid    = "AllowAccessToConfigBucket",
      effect = "Allow",
      resources = [
        "arn:aws:s3:::shared-services.eu-west-2.configs.ch.gov.uk/*",
        "arn:aws:s3:::shared-services.eu-west-2.configs.ch.gov.uk"
      ],
      actions = [
        "s3:Get*",
        "s3:List*",
      ]
    },
    {
      sid       = "AllowReadOnlyAccessToECR",
      effect    = "Allow",
      resources = ["*"],
      actions = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage",
        "ecr:GetLifecyclePolicy",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:ListTagsForResource",
        "ecr:DescribeImageScanFindings"
      ]
    },
    {
      sid       = "AllowReadOnlyDescribeAccessToEC2",
      effect    = "Allow",
      resources = ["*"],
      actions = [
        "ec2:Describe*"
      ]
    }
  ]
}