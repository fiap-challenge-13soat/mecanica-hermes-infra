module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.14.0"
  name    = "${var.project_name}-eks"

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

  enable_cluster_creator_admin_permissions = true
  endpoint_public_access                   = true
  authentication_mode                      = "API_AND_CONFIG_MAP"

  eks_managed_node_groups = {
    default = {
      create_iam_role = true
      min_size        = 2
      desired_size    = 4
      max_size        = 6
      instance_types  = ["t3.small"]
    }
  }

  # Allow control plane egress to node kubelet
  security_group_additional_rules = {
    egress_kubelet = {
      description                = "Allow control plane egress to kubelet"
      protocol                   = "tcp"
      from_port                  = 10250
      to_port                    = 10250
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Allow nodes to reach kubelet (required for monitoring agents with hostNetwork=true)
  node_security_group_additional_rules = {
    kubelet_self = {
      description = "Allow nodes to reach kubelet on same/other nodes (e.g. newrelic-infrastructure)"
      protocol    = "tcp"
      from_port   = 10250
      to_port     = 10250
      type        = "ingress"
      self        = true
    }
  }
}
