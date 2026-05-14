output "rds_instance_identifier" {
  description = "RDS instance identifier"
  value       = module.db.db_instance_identifier
}

output "rds_endpoint" {
  description = "RDS instance endpoint (hostname:port)"
  value       = module.db.db_instance_endpoint
}

output "rds_master_user_secret_arn" {
  description = "ARN of the Secrets Manager secret for RDS master user credentials"
  value       = module.db.db_instance_master_user_secret_arn
}
