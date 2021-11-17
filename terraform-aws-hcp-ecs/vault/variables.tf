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
  description = "Name for ECS task and service"
}

variable "product_database_address" {
  type        = string
  description = "Address for the product PostgreSQL database."
}

variable "product_database_username" {
  type        = string
  description = "Admin username for the product PostgreSQL database."
}

variable "product_database_password" {
  type        = string
  description = "Admin password for the product PostgreSQL database."
  sensitive   = true
}

variable "product_database_port" {
  type        = string
  description = "Port for the product PostgreSQL database. Default 5432."
  default     = "5432"
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags for resources"
  default = {
    Purpose = "hashicups-setups"
  }
}