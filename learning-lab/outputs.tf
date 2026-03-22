# Lambda VPC Configuration Outputs
output "lambda_security_group_id" {
  description = "Security group ID for Lambda functions to access RDS"
  value       = aws_security_group.lambda_sg.id
}

output "lambda_subnet_ids" {
  description = "Private subnet IDs for Lambda functions"
  value       = module.vpc.private_subnets
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}
