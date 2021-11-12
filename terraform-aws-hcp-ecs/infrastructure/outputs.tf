output "region" {
  value = var.region
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "boundary_endpoint" {
  value = "http://${module.boundary.boundary_lb}:9200"
}

output "boundary_kms_recovery_key_id" {
  value = module.boundary.kms_recovery_key_id
}

output "product_database_address" {
  value = aws_db_instance.products.address
}

output "product_database_username" {
  value = aws_db_instance.products.username
}

output "product_database_password" {
  value     = aws_db_instance.products.password
  sensitive = true
}

output "ecs_cluster" {
  value = aws_ecs_cluster.cluster.name
}

output "ecs_security_group" {
  value = aws_security_group.ecs.id
}

output "consul_attributes" {
  sensitive = true

  value = {
    datacenter                     = hcp_consul_cluster.consul.datacenter
    acl_secret_name_prefix         = local.acl_controller_prefix
    consul_server_ca_cert_arn      = aws_secretsmanager_secret.consul_ca_cert.arn
    gossip_key_secret_arn          = aws_secretsmanager_secret.gossip_key.arn
    consul_client_token_secret_arn = module.consul_acl_controller.client_token_secret_arn
    consul_retry_join              = jsondecode(base64decode(hcp_consul_cluster.consul.consul_config_file))["retry_join"][0]
  }
}

output "hcp_consul_public_endpoint" {
  value       = hcp_consul_cluster.consul.consul_public_endpoint_url
  description = "Public endpoint of HCP Consul"
  sensitive   = true
}

output "hcp_consul_root_token" {
  value       = hcp_consul_cluster_root_token.cluster.secret_id
  description = "Token of HCP Consul"
  sensitive   = true
}

output "hcp_vault_public_endpoint" {
  value       = hcp_vault_cluster.vault.vault_public_endpoint_url
  description = "Public endpoint of HCP Vault"
  sensitive   = true
}

output "hcp_vault_admin_token" {
  value       = hcp_vault_cluster_admin_token.cluster.token
  description = "Token of HCP Vault"
  sensitive   = true
}

output "hcp_vault_namespace" {
  value       = hcp_vault_cluster.vault.namespace
  description = "Namespace of HCP Vault"
}