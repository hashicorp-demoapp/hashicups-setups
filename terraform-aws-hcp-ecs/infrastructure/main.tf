terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.20"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.65"
    }
  }
}

provider "hcp" {}

provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}
