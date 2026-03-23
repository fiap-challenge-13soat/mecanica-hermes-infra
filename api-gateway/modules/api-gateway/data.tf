data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "main" {
  name = "${var.project_name}-eks"
}

data "aws_lb" "k8s_nlb" {
  tags = {
    "service.k8s.aws/stack"      = "mecanica-hermes-${var.environment}/mecanica-hermes-api"
    "kubernetes.io/service-name" = "mecanica-hermes-${var.environment}/mecanica-hermes-api"
  }
}
