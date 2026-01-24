module "db" {
  source     = "terraform-aws-modules/rds/aws"
  identifier = "${var.project_name}-rds"
  version    = "7.1.0"

  engine            = "postgres"
  engine_version    = "17.6"
  family            = "postgres17"
  instance_class    = "db.t4g.micro"
  allocated_storage = 10

  db_name  = "${var.project_name}db"
  username = "postgres"
  port     = "5432"

  vpc_security_group_ids = [aws_security_group.mainsg.id]
  create_db_subnet_group = false
  db_subnet_group_name   = module.vpc.database_subnet_group_name
}
