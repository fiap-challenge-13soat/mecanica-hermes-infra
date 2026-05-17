resource "random_password" "mq_admin" {
  length  = 24
  special = false
}

resource "aws_security_group" "mq_sg" {
  name        = "${var.project_name}-mq-sg"
  description = "Allow EKS nodes to connect to Amazon MQ (RabbitMQ)"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "AMQPS from EKS nodes"
    from_port       = 5671
    to_port         = 5671
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.project_name}-mq-sg"
    ManagedBy = "Terraform"
  }
}

resource "aws_mq_broker" "main" {
  broker_name                = "${var.project_name}-mq"
  engine_type                = "RabbitMQ"
  engine_version             = "3.13"
  host_instance_type         = "mq.m7g.medium"
  deployment_mode            = "SINGLE_INSTANCE"
  publicly_accessible        = false
  auto_minor_version_upgrade = true

  subnet_ids      = [module.vpc.private_subnets[0]]
  security_groups = [aws_security_group.mq_sg.id]

  user {
    username = "mechermes"
    password = random_password.mq_admin.result
  }

  tags = {
    Name      = "${var.project_name}-mq"
    ManagedBy = "Terraform"
  }
}

resource "aws_secretsmanager_secret" "mq" {
  name                    = "${var.project_name}-mq-secret"
  description             = "Amazon MQ (RabbitMQ) credentials for ${var.project_name}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "mq" {
  secret_id = aws_secretsmanager_secret.mq.id
  secret_string = jsonencode({
    username = "mechermes"
    password = random_password.mq_admin.result
    endpoint = tolist(aws_mq_broker.main.instances)[0].endpoints[0]
  })
}
