resource "aws_security_group" "mainsg" {
  name        = "${var.project_name}-sg"
  description = "Allow EKS nodes to access RDS"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "mainsg_ingress_from_nodes" {
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  security_group_id        = aws_security_group.mainsg.id
  source_security_group_id = module.eks.node_security_group_id
  description              = "Postgres from EKS nodes"
}

resource "aws_security_group_rule" "mainsg_ingress_from_lambda" {
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  security_group_id        = aws_security_group.mainsg.id
  source_security_group_id = aws_security_group.lambda_sg.id
  description              = "Postgres from Lambda functions"
}

resource "aws_security_group_rule" "mainsg_egress_all" {
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  security_group_id = aws_security_group.mainsg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Lambda Security Group
resource "aws_security_group" "lambda_sg" {
  name        = "${var.project_name}-lambda-sg"
  description = "Security group for Lambda functions"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "lambda_egress_all" {
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  security_group_id = aws_security_group.lambda_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
}
