# Needed for the task definition to be able to write logs to Cloudwatch.
resource "aws_iam_role" "hashicups" {
  name = "hashicupsLogs"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow"
        Principal = {
          #"AWS" = ["arn:aws:iam::561656980159:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"]
          "AWS" = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"]
        }
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_policy" "hashicups" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["secretsmanager:GetSecretValue"]
        Effect = "Allow"
        Resource = [
          aws_secretsmanager_secret.gossip_key.arn,
          aws_secretsmanager_secret.bootstrap_token.arn,
          aws_secretsmanager_secret.consul_ca_cert.arn,
          aws_lb.example_client_app.arn
        ]
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvent"
        ],
        Effect   = "Allow"
        Resource = ["*"]
      },
      {
        Action = ["elasticloadbalancing:*"]
        Effect = "Allow"
        Resource = [
          aws_lb.example_client_app.arn
        ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "hashicups" {
  policy_arn = aws_iam_policy.hashicups.arn
  role       = aws_iam_role.hashicups.name
}
