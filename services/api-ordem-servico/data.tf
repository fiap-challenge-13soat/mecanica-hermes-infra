data "aws_db_instance" "rds" {
  db_instance_identifier = "${var.project_name}-${var.environment}-rds"
}

data "aws_secretsmanager_secret_version" "docdb_password" {
  secret_id = local.docdb_shared.secret_arn
}