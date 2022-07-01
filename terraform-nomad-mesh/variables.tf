variable "frontend_url" {
  type    = string
  default = "hashicups-frontend.ingress.consul"
}

variable "datacenter" {
  description = "A list of datacenters in the region which are eligible for task placement."
  type        = string
  default     = "dc1"
}

variable "nomad_region" {
  description = "The region where the job should be placed."
  type        = string
  default     = "global"
}

variable "nomad_address" { type = string }

variable "nomad_token" { type = string }

variable "consul_address" {
  type    = string
  default = "http://localhost:8500"
}

variable "consul_token" { type = string }

variable "frontend_version" {
  description = "Docker version tag"
  default     = "v1.0.4"
}

variable "public_api_version" {
  description = "Docker version tag"
  default     = "v0.0.7"
}

variable "payments_version" {
  description = "Docker version tag"
  default     = "v0.0.16"
}

variable "product_api_version" {
  description = "Docker version tag"
  default     = "v0.0.22"
}

variable "product_api_db_version" {
  description = "Docker version tag"
  default     = "v0.0.22"
}

variable "postgres_db" {
  description = "Postgres DB name"
  default     = "products"
}

variable "postgres_user" {
  description = "Postgres DB User"
  default     = "postgres"
}

variable "postgres_password" {
  description = "Postgres DB Password"
  default     = "password"
}

variable "product_api_port" {
  description = "Product API Port"
  default     = 9090
}

variable "frontend_port" {
  description = "Frontend Port"
  default     = 3000
}

variable "payments_api_port" {
  description = "Payments API Port"
  default     = 8080
}

variable "public_api_port" {
  description = "Public API Port"
  default     = 8081
}
