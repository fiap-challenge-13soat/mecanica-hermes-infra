data "aws_db_instance" "rds" {
  db_instance_identifier = "${var.project_name}-${var.environment}-rds"
}

data "aws_docdb_cluster" "docdb" {
  cluster_identifier = "${var.project_name}-${var.environment}-docdb"
}
