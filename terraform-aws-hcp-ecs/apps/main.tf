terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.65"
    }
    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.14"
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
  datacenter = var.consul_attributes.datacenter
}
