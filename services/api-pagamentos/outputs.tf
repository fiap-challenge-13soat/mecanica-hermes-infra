output "docdb_cluster_identifier" {
  description = "DocumentDB cluster identifier"
  value       = aws_docdb_cluster.main.cluster_identifier
}

output "docdb_endpoint" {
  description = "DocumentDB cluster writer endpoint"
  value       = aws_docdb_cluster.main.endpoint
}

output "docdb_reader_endpoint" {
  description = "DocumentDB cluster reader endpoint"
  value       = aws_docdb_cluster.main.reader_endpoint
}

output "docdb_secret_arn" {
  description = "ARN of the Secrets Manager secret containing DocumentDB credentials"
  value       = aws_secretsmanager_secret.docdb.arn
}
