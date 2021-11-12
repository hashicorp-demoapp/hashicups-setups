variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
  validation {
    condition = contains([
      "us-east-1", "us-west-2",
      "eu-west-1", "eu-west-2", "eu-central-1",
      "ap-southeast-1", "ap-southeast-2"
    ], var.region)
    error_message = "Region must be a valid one for HCP."
  }
}

variable "name" {
  type        = string
  description = "Name for infrastructure resources"
}

variable "vpc_cidr_block" {
  type        = string
  description = "AWS VPC CIDR Block. Must be different than `hcp_network_cidr_block`."
  default     = "10.0.0.0/16"
}

variable "hcp_network_cidr_block" {
  type        = string
  description = "HCP CIDR Block for HashiCorp Virtual Network. Must be different than `vpc_cidr_block`."
  default     = "172.25.16.0/20"
}

variable "hcp_consul_tier" {
  type        = string
  description = "Tier for HCP Consul cluster."
  default     = "development"
  validation {
    condition = contains([
      "development", "standard", "plus"
    ], var.hcp_consul_tier)
    error_message = "Tier must be a valid one for HCP Consul."
  }
}

variable "hcp_consul_datacenter" {
  type        = string
  description = "Datacenter for HCP Consul cluster. Must be `dc1` to work with ECS modules."
  default     = "dc1"
}

variable "hcp_vault_tier" {
  type        = string
  description = "Tier for HCP Vault cluster."
  default     = "dev"
  validation {
    condition = contains([
      "dev", "standard_small", "standard_medium", "standard_large", "starter_small"
    ], var.hcp_vault_tier)
    error_message = "Tier must be a valid one for HCP Vault."
  }
}


variable "ecs_cluster_size" {
  default     = 1
  type        = number
  description = "Number of EC2 instances to create as ECS container instances."
}

variable "database_username" {
  default     = "postgres"
  type        = string
  description = "Username for products PostgreSQL database."
}

variable "database_password" {
  type        = string
  description = "Password for products PostgreSQL database."
  sensitive   = true
}

variable "boundary_database_password" {
  type        = string
  description = "Password for Boundary PostgreSQL database."
  sensitive   = true
}

variable "key_pair_name" {
  type        = string
  description = "AWS key pair to log into EC2 instances."
}

variable "allow_cidr_blocks" {
  type        = list(string)
  description = "Client CIDR blocks to allow access to EC2 instances and Boundary."
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags for resources"
  default = {
    Purpose = "hashicups-setups"
  }
}
