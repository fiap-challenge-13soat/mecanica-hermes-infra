data "aws_db_instance" "rds" {
  db_instance_identifier = "${var.project_name}-${var.environment}-rds"
}

data "aws_docdb_cluster" "shared" {
  cluster_identifier = "${var.project_name}-${var.environment}-docdb"
}

data "aws_secretsmanager_secret" "docdb" {
  name = "${var.project_name}-${var.environment}-docdb-secret"
}

data "aws_secretsmanager_secret_version" "docdb_password" {
  secret_id = data.aws_secretsmanager_secret.docdb.arn
}
