locals {
  docdb_shared = {
    cluster_identifier = "${var.project_name}-${var.environment}-docdb"
    endpoint           = data.aws_rds_cluster.shared.endpoint
    reader_endpoint    = data.aws_rds_cluster.shared.reader_endpoint
    secret_arn         = data.aws_secretsmanager_secret.docdb.arn
  }

  docdb_creds = jsondecode(
    data.aws_secretsmanager_secret_version.docdb_password.secret_string
  )
}
