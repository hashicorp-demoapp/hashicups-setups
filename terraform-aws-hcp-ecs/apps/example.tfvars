name   = "hashicups"
region = "us-west-2"

ecs_cluster        = "hashicups"
ecs_security_group = ""

allow_cidr_blocks = ["0.0.0.0/0"]

product_database_address = ""

consul_attributes = {
  "acl_secret_name_prefix"         = ""
  "consul_client_token_secret_arn" = ""
  "consul_retry_join"              = ""
  "consul_server_ca_cert_arn"      = ""
  "datacenter"                     = "dc1"
  "gossip_key_secret_arn"          = ""
}

vpc_id          = ""
private_subnets = []
public_subnets  = []
