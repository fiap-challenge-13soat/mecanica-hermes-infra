module "cognito" {
  source = "./modules/cognito"

  project_name               = var.project_name
  environment                = var.environment
  cognito_domain_prefix      = var.cognito_domain_prefix != "" ? var.cognito_domain_prefix : "${var.project_name}-${var.environment}"
  user_pool_name             = var.user_pool_name != "" ? var.user_pool_name : "${var.project_name}-${var.environment}-userpool"
  resource_server_identifier = var.resource_server_identifier
  resource_server_name       = var.resource_server_name
}
