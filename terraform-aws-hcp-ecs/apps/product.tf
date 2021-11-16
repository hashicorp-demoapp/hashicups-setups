locals {
  product_log_config = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.log_group.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "product"
    }
  }
  product_api_name = "${var.name}-product-api"
  product_api_port = 9090
}


resource "aws_iam_policy" "vault" {
  name        = "${var.name}-product-vault"
  path        = "/ecs/"
  description = "${var.name}-product-vault for AWS IAM Auth Method for Vault"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "iam:GetInstanceProfile",
        "iam:GetUser",
        "iam:GetRole"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_ecs_service" "product_api" {
  name            = local.product_api_name
  cluster         = var.ecs_cluster
  task_definition = module.product_api.task_definition_arn
  desired_count   = 1
  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.ecs_security_group]
  }
  launch_type            = "EC2"
  propagate_tags         = "TASK_DEFINITION"
  enable_execute_command = true
}

module "product_api" {
  source                        = "hashicorp/consul-ecs/aws//modules/mesh-task"
  version                       = "0.2.0"
  requires_compatibilities      = ["EC2"]
  family                        = local.product_api_name
  port                          = local.product_api_port
  log_configuration             = local.product_log_config
  additional_task_role_policies = [aws_iam_policy.vault.arn]
  volumes = [
    {
      name = "config",
      dockerVolumeConfiguration = {
        scope         = "shared"
        autoprovision = true
        driver        = "local"
      }
    }
  ]
  container_definitions = [
    {
      name             = "vault"
      image            = "joatmon08/vault-agent-ecs:1.8.5"
      essential        = false
      logConfiguration = local.product_log_config
      environment = [
        {
          name  = "VAULT_ADDR"
          value = var.hcp_vault_private_endpoint
        },
        {
          name  = "VAULT_NAMESPACE"
          value = var.hcp_vault_namespace
        },
        {
          name  = "AWS_IAM_ROLE"
          value = var.name
        },
        {
          name = "CONFIG_FILE_TEMPLATE"
          value = base64encode(templatefile("templates/conf.json", {
            vault_database_creds_path = var.product_database_credentials_path,
            database_address          = var.product_database_address,
            products_api_port         = local.product_api_port
          }))
        },
        {
          name  = "CONFIG_FILE_NAME"
          value = "conf.json"
        }
      ]
      cpu = 0
      mountPoints = [{
        sourceVolume  = "config"
        containerPath = "/config"
      }]
      volumesFrom = []
    },
    {
      name             = "product-api"
      image            = "hashicorpdemoapp/product-api:v0.0.19"
      essential        = true
      logConfiguration = local.product_log_config
      dependsOn = [{
        containerName = "vault"
        condition     = "SUCCESS"
      }]
      environment = [
        {
          name  = "NAME"
          value = local.product_api_name
        },
        {
          name  = "CONFIG_FILE",
          value = "/config/conf.json"
        }
      ]
      portMappings = [
        {
          containerPort = local.product_api_port
          hostPort      = local.product_api_port
          protocol      = "tcp"
        }
      ]
      cpu = 0
      mountPoints = [{
        sourceVolume  = "config"
        containerPath = "/config"
      }]
      volumesFrom = []
  }]
  retry_join                     = [var.consul_attributes.consul_retry_join]
  tls                            = true
  consul_server_ca_cert_arn      = var.consul_attributes.consul_server_ca_cert_arn
  gossip_key_secret_arn          = var.consul_attributes.gossip_key_secret_arn
  acls                           = true
  consul_client_token_secret_arn = var.consul_attributes.consul_client_token_secret_arn
  acl_secret_name_prefix         = var.consul_attributes.acl_secret_name_prefix
}
