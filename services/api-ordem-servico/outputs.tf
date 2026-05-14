output "rds_address" {
  description = "Shared RDS hostname for ordem-servico PostgreSQL database"
  value       = data.aws_db_instance.rds.address
}

output "rds_endpoint" {
  description = "Shared RDS endpoint (hostname:port) for ordem-servico PostgreSQL database"
  value       = data.aws_db_instance.rds.endpoint
}

output "docdb_endpoint" {
  description = "Shared DocumentDB writer endpoint for ordem-servico saga state"
  value       = data.aws_docdb_cluster.docdb.endpoint
}
