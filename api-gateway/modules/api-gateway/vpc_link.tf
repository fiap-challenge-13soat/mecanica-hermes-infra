resource "aws_security_group" "vpc_link" {
  name        = "${var.project_name}-${var.environment}-vpc-link-sg"
  description = "Security group for API Gateway VPC Link"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow all outbound traffic to NLB"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc-link-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_apigatewayv2_vpc_link" "main" {
  name               = "${var.project_name}-${var.environment}-vpc-link"
  security_group_ids = [aws_security_group.vpc_link.id]
  subnet_ids         = var.private_subnets

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc-link"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
