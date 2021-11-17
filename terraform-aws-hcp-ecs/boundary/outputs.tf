output "boundary_auth_method_id" {
  value = boundary_auth_method.password.id
}

output "boundary_operations_password" {
  value     = random_password.operations_team.result
  sensitive = true
}

output "boundary_products_password" {
  value     = random_password.products_team.result
  sensitive = true
}

output "boundary_security_password" {
  value     = random_password.security_team.result
  sensitive = true
}

output "boundary_target_ecs" {
  value = boundary_target.ecs.id
}

output "boundary_target_postgres" {
  value = boundary_target.products_database_postgres.id
}

output "boundary_endpoint" {
  value = var.boundary_endpoint
}