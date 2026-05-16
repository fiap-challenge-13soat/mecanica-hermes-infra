output "cognito_user_pool_id" {
  description = "ID do Cognito User Pool"
  value       = module.cognito.user_pool_id
}

output "cognito_user_pool_arn" {
  description = "ARN do Cognito User Pool"
  value       = module.cognito.user_pool_arn
}

output "cognito_client_id" {
  description = "ID do Cognito User Pool Client (não sensível)"
  value       = module.cognito.client_id
}

output "cognito_domain" {
  description = "Domínio do Cognito"
  value       = module.cognito.domain
}

output "cognito_token_endpoint" {
  description = "Endpoint OAuth2 para obtenção de tokens"
  value       = module.cognito.token_endpoint
}

output "cognito_scopes" {
  description = "Scopes disponíveis"
  value       = module.cognito.scopes
}

output "cognito_secret_arn" {
  description = "ARN do secret no AWS Secrets Manager"
  value       = module.cognito.secret_arn
}

output "cognito_secret_name" {
  description = "Nome do secret no AWS Secrets Manager"
  value       = module.cognito.secret_name
}
