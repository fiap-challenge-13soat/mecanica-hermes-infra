output "api_gateway_id" {
  description = "ID do API Gateway"
  value       = aws_apigatewayv2_api.main.id
}

output "api_gateway_endpoint" {
  description = "URL do endpoint do API Gateway"
  value       = aws_apigatewayv2_api.main.api_endpoint
}

output "api_gateway_arn" {
  description = "ARN do API Gateway"
  value       = aws_apigatewayv2_api.main.arn
}

output "vpc_link_id" {
  description = "ID do VPC Link"
  value       = aws_apigatewayv2_vpc_link.main.id
}

output "vpc_link_arn" {
  description = "ARN do VPC Link"
  value       = aws_apigatewayv2_vpc_link.main.arn
}

output "authorizer_id" {
  description = "ID do Cognito Authorizer"
  value       = aws_apigatewayv2_authorizer.cognito.id
}

output "stage_invoke_url" {
  description = "URL de invocação completa do API Gateway"
  value       = aws_apigatewayv2_stage.main.invoke_url
}
