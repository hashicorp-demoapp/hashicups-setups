module "vpc" {
  source  = "registry.terraform.io/terraform-aws-modules/vpc/aws"
  version = "2.78.0"

  name                 = var.cluster_cidrs.ecs_cluster.name
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.cluster_cidrs.ecs_cluster.private_subnets
  public_subnets       = var.cluster_cidrs.ecs_cluster.public_subnets
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}
