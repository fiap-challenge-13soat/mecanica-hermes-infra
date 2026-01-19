module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"
  name    = "mechermes-vpc"

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

module "db" {
  source     = "terraform-aws-modules/rds/aws"
  identifier = "mechermes-rds"
  version    = "7.1.0"

  engine            = "postgres"
  engine_version    = "17.6"
  family            = "postgres17"
  instance_class    = "db.t4g.micro"
  allocated_storage = 10

  db_name  = "mecanicahermestfdb"
  username = "postgres"
  port     = "5432"

  vpc_security_group_ids = [module.vpc.default_security_group_id]
  db_subnet_group_name   = module.vpc.database_subnet_group
}

module "eks" {
  # source  = "terraform-aws-modules/eks/aws"
  # version = "21.14.0"
  source = "./module-eks"
  name   = "mechermes-eks"

  kubernetes_version = "1.34"

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  enable_cluster_creator_admin_permissions = false
  endpoint_public_access                   = true
  authentication_mode                      = "API_AND_CONFIG_MAP"

  enable_irsa = false

  access_entries = {
    cluster_admin = {
      principal_arn = var.lab_role_arn

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  eks_managed_node_groups = {
    default = {
      create_iam_role = false
      iam_role_arn    = var.lab_role_arn
      min_size        = 1
      desired_size    = 1
      instance_types  = ["t3.micro"]
    }
  }

  # Variáveis para funcionamento no Learning Lab
  aws_iam_session_context_current_arn = data.aws_caller_identity.current.arn
  iam_role_arn                        = var.lab_role_arn
  create_iam_role                     = false
  create_node_iam_role                = false
  create_kms_key                      = false
  encryption_config                   = null
}
