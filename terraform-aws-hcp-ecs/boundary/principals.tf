resource "boundary_user" "operations" {
  for_each    = var.operations_team
  name        = each.key
  description = "Operations user: ${each.key}"
  account_ids = [boundary_account.operations_user_acct[each.value].id]
  scope_id    = boundary_scope.org.id
}

resource "boundary_user" "products" {
  for_each    = var.products_team
  name        = each.key
  description = "Products user: ${each.key}"
  account_ids = [boundary_account.products_user_acct[each.value].id]
  scope_id    = boundary_scope.org.id
}

resource "boundary_user" "security" {
  for_each    = var.security_team
  name        = each.key
  description = "WARNING: Managers should be read-only"
  account_ids = [boundary_account.security_user_acct[each.value].id]
  scope_id    = boundary_scope.org.id
}

resource "random_password" "operations_team" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "boundary_account" "operations_user_acct" {
  for_each       = var.operations_team
  name           = each.key
  description    = "User account for ${each.key}"
  type           = "password"
  login_name     = lower(each.key)
  password       = random_password.operations_team.result
  auth_method_id = boundary_auth_method.password.id
}

resource "random_password" "products_team" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "boundary_account" "products_user_acct" {
  for_each       = var.products_team
  name           = each.key
  description    = "User account for ${each.key}"
  type           = "password"
  login_name     = lower(each.key)
  password       = random_password.products_team.result
  auth_method_id = boundary_auth_method.password.id
}

resource "random_password" "security_team" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "boundary_account" "security_user_acct" {
  for_each       = var.security_team
  name           = each.key
  description    = "User account for ${each.key}"
  type           = "password"
  login_name     = lower(each.key)
  password       = random_password.security_team.result
  auth_method_id = boundary_auth_method.password.id
}

// organiation level group for the security team
resource "boundary_group" "security" {
  name        = "security_team"
  description = "Organization group for security team"
  member_ids  = [for user in boundary_user.security : user.id]
  scope_id    = boundary_scope.org.id
}

// project level group for management of core infra
resource "boundary_group" "operations_team" {
  name        = "operations"
  description = "Operations team group"
  member_ids  = [for user in boundary_user.operations : user.id]
  scope_id    = boundary_scope.core_infra.id
}

// project level group for management of products infra
resource "boundary_group" "products_team" {
  name        = "products"
  description = "Products team group"
  member_ids  = [for user in boundary_user.products : user.id]
  scope_id    = boundary_scope.products_infra.id
}