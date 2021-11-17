data "aws_caller_identity" "current" {}

data "aws_iam_roles" "ecs" {
  name_regex = "${var.name}-product-api-task"
}

resource "vault_auth_backend" "aws" {
  type = "aws"
}

resource "vault_aws_auth_backend_sts_role" "ecs" {
  for_each   = data.aws_iam_roles.ecs.arns
  backend    = vault_auth_backend.aws.path
  account_id = data.aws_caller_identity.current.account_id
  sts_role   = each.key
}

resource "vault_aws_auth_backend_role" "ecs" {
  count                    = length(data.aws_iam_roles.ecs.arns) > 0 ? 1 : 0
  backend                  = vault_auth_backend.aws.path
  role                     = var.name
  auth_type                = "iam"
  resolve_aws_unique_ids   = false
  bound_iam_principal_arns = data.aws_iam_roles.ecs.arns
  token_policies           = ["product"]
}
