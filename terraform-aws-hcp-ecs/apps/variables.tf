variable "name" {
  type        = string
  description = "Name for ECS task and service"
}

variable "region" {
  type        = string
  description = "AWS region for Boundary cluster"
}

variable "ecs_cluster" {
  type        = string
  description = "Name of AWS ECS cluster"
}

variable "ecs_security_group" {
  type        = string
  description = "Security group ID of AWS ECS cluster"
}

variable "allow_cidr_blocks" {
  type        = list(string)
  description = "Client CIDR blocks to allow access to EC2 instances and Boundary."
}

variable "product_database_address" {
  type        = string
  description = "Address of products PostgreSQL database"
}

variable "product_database_credentials_path" {
  type        = string
  description = "Vault credentials path for products PostgreSQL database"
}

variable "consul_attributes" {
  type        = map(string)
  description = "Attributes for ECS to connect to HCP Consul"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for services"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnets for services"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets for load balancer"
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags for resources"
  default = {
    Purpose = "hashicups-setups"
  }
}

variable "hcp_vault_private_endpoint" {
  type        = string
  description = "Private endpoint of HCP Vault"
  sensitive   = true
}

variable "hcp_vault_namespace" {
  type        = string
  description = "Namespace of HCP Vault"
}