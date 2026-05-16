output "api_gateway_id" {
  description = "ID do API Gateway"
  value       = module.api_gateway.api_gateway_id
}

output "api_gateway_endpoint" {
  description = "URL do endpoint do API Gateway"
  value       = module.api_gateway.api_gateway_endpoint
}

output "api_gateway_arn" {
  description = "ARN do API Gateway"
  value       = module.api_gateway.api_gateway_arn
}

output "vpc_link_id" {
  description = "ID do VPC Link"
  value       = module.api_gateway.vpc_link_id
}

output "vpc_link_arn" {
  description = "ARN do VPC Link"
  value       = module.api_gateway.vpc_link_arn
}

output "authorizer_id" {
  description = "ID do Cognito Authorizer"
  value       = module.api_gateway.authorizer_id
}

output "stage_invoke_url" {
  description = "URL de invocação completa do API Gateway"
  value       = module.api_gateway.stage_invoke_url
}
