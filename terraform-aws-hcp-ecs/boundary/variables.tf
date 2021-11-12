variable "name" {
  type        = string
  description = "Name of the organization in Boundary"
}

variable "region" {
  type        = string
  description = "AWS region for Boundary cluster"
}

variable "operations_team" {
  type        = set(string)
  description = "List of operations team members"
}

variable "products_team" {
  type        = set(string)
  description = "List of products team members"
}

variable "security_team" {
  type        = set(string)
  description = "List of security team members"
}

variable "boundary_endpoint" {
  type        = string
  description = "Endpoint for Boundary cluster"
}

variable "boundary_kms_recovery_key_id" {
  type        = string
  description = "AWS KMS recovery key ID for Boundary cluster"
}

variable "ecs_cluster" {
  type        = string
  description = "Name of AWS ECS cluster"
}

data "aws_instances" "ecs" {
  instance_tags = {
    "Cluster" = var.ecs_cluster
  }
}

variable "product_database_address" {
  type        = string
  description = "Address of products PostgreSQL database"
}
