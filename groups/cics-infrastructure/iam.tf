module "cics_profile" {
  source = "git@github.com:companieshouse/terraform-modules//aws/instance_profile?ref=tags/1.0.361"

  name       = "cics-profile"
  enable_ssm = true

  s3_buckets_write = [local.session_manager_bucket_name]

  kms_key_refs = [
    "alias/${var.account}/${var.region}/ebs",
    local.ssm_kms_key_id
  ]

  cw_log_group_arns = length(local.log_groups) > 0 ? flatten([
    formatlist(
      "arn:aws:logs:%s:%s:log-group:%s:*:*",
      var.aws_region,
      data.aws_caller_identity.current.account_id,
      local.log_groups
    ),
    formatlist("arn:aws:logs:%s:%s:log-group:%s:*",
      var.aws_region,
      data.aws_caller_identity.current.account_id,
      local.log_groups
    ),
  ]) : null

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
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
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

resource "aws_iam_role_policy_attachment" "inspector_cis_scanning_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonInspector2ManagedCisPolicy"
  role       = module.cics_profile.aws_iam_role.name
}
