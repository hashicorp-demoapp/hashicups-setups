locals {
  boundary_creds_path = "${vault_mount.postgres.path}/creds/boundary"
}

data "vault_policy_document" "boundary_controller" {
  rule {
    path         = "auth/token/lookup-self"
    capabilities = ["read"]
  }

  rule {
    path         = "auth/token/renew-self"
    capabilities = ["update"]
  }

  rule {
    path         = "auth/token/revoke-self"
    capabilities = ["update"]
  }

  rule {
    path         = "sys/leases/renew"
    capabilities = ["update"]
  }

  rule {
    path         = "sys/leases/revoke"
    capabilities = ["update"]
  }

  rule {
    path         = "sys/capabilities-self"
    capabilities = ["update"]
  }
}

resource "vault_policy" "boundary_controller" {
  name   = "boundary-controller"
  policy = data.vault_policy_document.boundary_controller.hcl
}

data "vault_policy_document" "boundary_product" {
  rule {
    path         = local.boundary_creds_path
    capabilities = ["read"]
    description  = "read all credentials for product database as boundary"
  }
}

resource "vault_policy" "boundary_product" {
  name   = "boundary"
  policy = data.vault_policy_document.boundary_product.hcl
}

resource "vault_token" "boundary" {
  role_name = vault_token_auth_backend_role.boundary.role_name
  policies  = [vault_policy.boundary_product.name, vault_policy.boundary_controller.name]
  period    = "24h"
}

resource "vault_token_auth_backend_role" "boundary" {
  role_name           = "boundary"
  allowed_policies    = [vault_policy.boundary_product.name, vault_policy.boundary_controller.name]
  disallowed_policies = ["default"]
  orphan              = true
  renewable           = true
}

resource "vault_database_secret_backend_role" "boundary" {
  backend               = vault_mount.postgres.path
  name                  = "boundary"
  db_name               = vault_database_secret_backend_connection.postgres.name
  creation_statements   = ["CREATE ROLE \"{{username}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO \"{{username}}\"; GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO \"{{username}}\";"]
  revocation_statements = ["ALTER ROLE \"{{username}}\" NOLOGIN;"]
  default_ttl           = 3600
  max_ttl               = 3600
}
