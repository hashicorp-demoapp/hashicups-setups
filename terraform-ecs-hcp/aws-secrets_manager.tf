locals {
  name                 = var.name
  bootstrap_token_name = "${local.name}-bootstrap-token"
  gossip_key_name      = "${local.name}-gossip-key"
  consul_ca_cert_name  = "${local.name}-consul-ca-cert"
}

resource "aws_secretsmanager_secret" "bootstrap_token" {
  name                    = local.bootstrap_token_name
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "bootstrap_token" {
  secret_id     = aws_secretsmanager_secret.bootstrap_token.id
  secret_string = hcp_consul_cluster.example.consul_root_token_secret_id
}

resource "aws_secretsmanager_secret" "gossip_key" {
  name                    = local.gossip_key_name
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "gossip_key" {
  secret_id     = aws_secretsmanager_secret.gossip_key.id
  secret_string = jsondecode(base64decode(hcp_consul_cluster.example.consul_config_file))["encrypt"]
}

resource "aws_secretsmanager_secret" "consul_ca_cert" {
  name                    = local.consul_ca_cert_name
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "consul_ca_cert" {
  secret_id     = aws_secretsmanager_secret.consul_ca_cert.id
  secret_string = base64decode(hcp_consul_cluster.example.consul_ca_file)
}