resource "hcp_hvn" "hvn" {
  hvn_id         = var.name
  cloud_provider = "aws"
  region         = var.region
  cidr_block     = var.hcp_network_cidr_block
}

resource "hcp_consul_cluster" "consul" {
  hvn_id          = hcp_hvn.hvn.hvn_id
  cluster_id      = var.name
  tier            = var.hcp_consul_tier
  datacenter      = var.hcp_consul_datacenter
  public_endpoint = true
}

resource "hcp_vault_cluster" "vault" {
  cluster_id      = var.name
  hvn_id          = hcp_hvn.hvn.hvn_id
  tier            = var.hcp_vault_tier
  public_endpoint = true
}

resource "hcp_vault_cluster_admin_token" "cluster" {
  cluster_id = hcp_vault_cluster.vault.cluster_id
}

locals {
  route_table_ids = concat(module.vpc.private_route_table_ids, module.vpc.public_route_table_ids)
}

resource "hcp_aws_network_peering" "peer" {
  hvn_id          = hcp_hvn.hvn.hvn_id
  peer_vpc_id     = module.vpc.vpc_id
  peer_account_id = module.vpc.vpc_owner_id
  peer_vpc_region = var.region
  peering_id      = hcp_hvn.hvn.hvn_id
}

resource "aws_vpc_peering_connection_accepter" "hvn" {
  vpc_peering_connection_id = hcp_aws_network_peering.peer.provider_peering_id
  auto_accept               = true
}

resource "aws_route" "hvn" {
  count                     = length(local.route_table_ids)
  route_table_id            = local.route_table_ids[count.index]
  destination_cidr_block    = var.hcp_network_cidr_block
  vpc_peering_connection_id = hcp_aws_network_peering.peer.provider_peering_id
}

resource "hcp_hvn_route" "hvn" {
  hvn_link         = hcp_hvn.hvn.self_link
  hvn_route_id     = "${hcp_hvn.hvn.hvn_id}-to-vpc"
  destination_cidr = module.vpc.vpc_cidr_block
  target_link      = hcp_aws_network_peering.peer.self_link
}
