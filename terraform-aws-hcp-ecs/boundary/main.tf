terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.65"
    }
    boundary = {
      source  = "hashicorp/boundary"
      version = "~> 1.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "boundary" {
  addr             = var.boundary_endpoint
  recovery_kms_hcl = <<EOT
kms "awskms" {
	purpose    = "recovery"
  region = "${var.region}"
	key_id     = "global_root"
  kms_key_id = "${var.boundary_kms_recovery_key_id}"
}
EOT
}

