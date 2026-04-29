data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "main" {
  name = "${var.project_name}-eks"
}

