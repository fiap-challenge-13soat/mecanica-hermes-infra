module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"
  name    = "${var.project_name}-vpc"

  cidr            = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  database_subnets             = ["10.0.151.0/24", "10.0.152.0/24"]
  create_database_subnet_group = true

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_support   = true
  enable_dns_hostnames = true
}
