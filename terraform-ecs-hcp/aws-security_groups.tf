locals {
  # In the future, if this value changes from var.name to var.foo, you will
  # only update this "pointer" value to the new variable name, instead of updating
  # every reference if using this variable multiple times.
  local_name                   = var.name
  security_group_name          = "example-client-app-alb"
  security_group_resource_name = "${local.name}-${local.security_group_name}"
  ingress_cidr_block           = "${var.lb_ingress_ip}/32"
  egress_cidr_block            = "0.0.0.0/0"
}


resource "aws_security_group" "example_client_app_alb" {
  name   = local.security_group_resource_name
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "Access to example client application."
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0", local.ingress_cidr_block]
  }

  ingress {
    description = "Access to example client application."
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0", local.ingress_cidr_block]
  }

  ingress {
    description = "Access to example client application."
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Access to example client application."
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.egress_cidr_block]
  }
}

resource "aws_security_group_rule" "ingress_from_client_alb_to_ecs" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.example_client_app_alb.id
  security_group_id        = data.aws_security_group.vpc_default.id
}