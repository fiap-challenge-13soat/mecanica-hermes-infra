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
  # Pulling from locals.tf instead of a data source
  value       = local.docdb_shared.endpoint
}

output "docdb_reader_endpoint" {
  description = "Shared DocumentDB reader endpoint for ordem-servico saga state"
  # Extra output useful for read-only scaling
  value       = local.docdb_shared.reader_endpoint
}

output "docdb_cluster_identifier" {
  description = "The identifier of the shared DocumentDB cluster"
  value       = local.docdb_shared.cluster_identifier
}