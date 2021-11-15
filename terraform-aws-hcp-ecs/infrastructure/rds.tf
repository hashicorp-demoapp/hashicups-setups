resource "aws_security_group" "database" {
  name        = "${var.name}-database"
  description = "Allow inbound traffic to database"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow inbound from ECS and Boundary worker"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id, module.boundary.boundary_security_group]
  }

  ingress {
    description = "Allow inbound from HCP Vault"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.hcp_network_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "products" {
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "11.12"
  instance_class         = "db.t3.micro"
  name                   = "products"
  identifier             = "${var.name}-products"
  username               = var.database_username
  password               = var.database_password
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  vpc_security_group_ids = [aws_security_group.database.id]
  skip_final_snapshot    = true
  tags = {
    Component = "products-db"
  }
}
