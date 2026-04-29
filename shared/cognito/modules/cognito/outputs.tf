output "user_pool_id" {
  description = "ID do Cognito User Pool"
  value       = aws_cognito_user_pool.main.id
}

output "user_pool_arn" {
  description = "ARN do Cognito User Pool"
  value       = aws_cognito_user_pool.main.arn
}

output "client_id" {
  description = "ID do Cognito User Pool Client (não sensível)"
  value       = aws_cognito_user_pool_client.main.id
}

output "domain" {
  description = "Domínio do Cognito"
  value       = aws_cognito_user_pool_domain.main.domain
}

output "token_endpoint" {
  description = "Endpoint OAuth2 para obtenção de tokens"
  value       = "https://${aws_cognito_user_pool_domain.main.domain}.auth.${data.aws_region.current.id}.amazoncognito.com/oauth2/token"
}

output "resource_server_identifier" {
  description = "Identificador do Resource Server"
  value       = var.resource_server_identifier
}

output "scopes" {
  description = "Scopes disponíveis"
  value = [
    "${var.resource_server_identifier}/admin",
    "${var.resource_server_identifier}/client"
  ]
}

output "secret_arn" {
  description = "ARN do secret no AWS Secrets Manager contendo as credenciais"
  value       = aws_secretsmanager_secret.cognito_credentials.arn
}

output "secret_name" {
  description = "Nome do secret no AWS Secrets Manager"
  value       = aws_secretsmanager_secret.cognito_credentials.name
}
