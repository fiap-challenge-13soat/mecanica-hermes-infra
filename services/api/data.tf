data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-vpc"]
  }
}

data "aws_security_group" "mainsg" {
  filter {
    name   = "group-name"
    values = ["${var.project_name}-sg"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

data "aws_db_subnet_group" "db" {
  name = "${var.project_name}-vpc"
}
