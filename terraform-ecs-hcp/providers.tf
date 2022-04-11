terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">3.0.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.14.0"
    }
    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.15.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}

provider "consul" {
  address    = hcp_consul_cluster.example.consul_public_endpoint_url
  token      = hcp_consul_cluster.example.consul_root_token_secret_id
  datacenter = var.hcp_datacenter_name
}

provider "hcp" {}

