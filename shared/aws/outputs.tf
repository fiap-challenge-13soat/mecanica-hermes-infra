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

output "mq_broker_id" {
  description = "Amazon MQ broker ID"
  value       = aws_mq_broker.main.id
}

output "mq_endpoint" {
  description = "Amazon MQ AMQPS endpoint"
  value       = tolist(aws_mq_broker.main.instances)[0].endpoints[0]
}

output "mq_secret_arn" {
  description = "ARN of the Secrets Manager secret holding MQ credentials"
  value       = aws_secretsmanager_secret.mq.arn
}
