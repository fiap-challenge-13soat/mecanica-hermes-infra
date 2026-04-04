module "eks" {
  source = "./module-eks"
  name   = "${var.project_name}-eks"

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
      principal_arn = local.lab_role_arn

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    },
    user_admin = {
      principal_arn = local.user_role_arn

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
      iam_role_arn    = local.lab_role_arn
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

  # Allow control plane to reach kubelet (logs/port-forward)
  node_security_group_additional_rules = {
    kubelet_logs_primary = {
      description              = "Allow primary cluster SG to reach kubelet"
      protocol                 = "tcp"
      from_port                = 10250
      to_port                  = 10250
      type                     = "ingress"
      source_security_group_id = aws_security_group.mainsg.id
    }
  }

  # Variáveis para funcionamento no Learner Lab
  aws_iam_session_context_current_arn = data.aws_caller_identity.current.arn
  iam_role_arn                        = local.lab_role_arn
  create_iam_role                     = false
  create_node_iam_role                = false
  create_kms_key                      = false
  encryption_config                   = null
}
