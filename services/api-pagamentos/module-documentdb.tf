resource "aws_security_group" "docdb" {
  name        = "${var.project_name}-docdb-sg"
  description = "Allow VPC resources to access DocumentDB"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [data.aws_security_group.eks_nodes.id]
    description     = "DocumentDB from EKS nodes"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_docdb_subnet_group" "main" {
  name        = "${var.project_name}-${var.environment}-docdb"
  subnet_ids  = data.aws_subnets.database.ids
  description = "DocumentDB subnet group for ${var.project_name} ${var.environment}"
}

resource "aws_docdb_cluster_parameter_group" "main" {
  family      = "docdb5.0"
  name        = "${var.project_name}-${var.environment}-docdb-params"
  description = "DocumentDB cluster parameter group"

  parameter {
    name  = "tls"
    value = "disabled"
  }
}

resource "random_password" "docdb" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "docdb" {
  name                    = "${var.project_name}-${var.environment}-docdb-secret"
  description             = "DocumentDB master credentials for ${var.project_name} ${var.environment}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "docdb" {
  secret_id = aws_secretsmanager_secret.docdb.id
  secret_string = jsonencode({
    username = "docdbadmin"
    password = random_password.docdb.result
  })
}

resource "aws_docdb_cluster" "main" {
  cluster_identifier              = "${var.project_name}-${var.environment}-docdb"
  engine                          = "docdb"
  engine_version                  = "5.0.0"
  master_username                 = "docdbadmin"
  master_password                 = random_password.docdb.result
  db_subnet_group_name            = aws_docdb_subnet_group.main.name
  vpc_security_group_ids          = [aws_security_group.docdb.id]
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.main.name

  backup_retention_period   = 7
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.project_name}-${var.environment}-docdb-final"
  storage_encrypted         = true

  depends_on = [aws_secretsmanager_secret_version.docdb]
}

resource "aws_docdb_cluster_instance" "main" {
  identifier         = "${var.project_name}-${var.environment}-docdb-instance"
  cluster_identifier = aws_docdb_cluster.main.id
  instance_class     = "db.t3.medium"
  engine             = "docdb"
}
