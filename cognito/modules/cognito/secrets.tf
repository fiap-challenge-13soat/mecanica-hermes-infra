resource "aws_secretsmanager_secret" "cognito_credentials" {
  name                    = "${var.project_name}-${var.environment}-cognito-credentials"
  description             = "Cognito client credentials for ${var.environment} environment"
  recovery_window_in_days = 7

  tags = {
    Name        = "${var.project_name}-${var.environment}-cognito-credentials"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_secretsmanager_secret_version" "cognito_credentials" {
  secret_id = aws_secretsmanager_secret.cognito_credentials.id
  secret_string = jsonencode({
    client_id     = aws_cognito_user_pool_client.main.id
    client_secret = aws_cognito_user_pool_client.main.client_secret
    domain        = aws_cognito_user_pool_domain.main.domain
    region        = data.aws_region.current.id
    user_pool_id  = aws_cognito_user_pool.main.id
  })
}

data "aws_region" "current" {}
