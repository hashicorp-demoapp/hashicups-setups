resource "hcp_consul_cluster" "example" {
  cluster_id      = var.hcp_datacenter_name
  hvn_id          = hcp_hvn.server.hvn_id
  tier            = "development"
  public_endpoint = true
  connect_enabled = true
}