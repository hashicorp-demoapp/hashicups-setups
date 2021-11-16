terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.24"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.65"
    }
  }
}

provider "vault" {}

provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}
