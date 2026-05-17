module "api_gateway" {
  source = "./modules/api-gateway"

  project_name                   = var.project_name
  environment                    = var.environment
  cognito_user_pool_arn          = var.cognito_user_pool_arn
  cognito_app_client_id          = var.cognito_app_client_id
  lambda_function_arn            = var.lambda_function_arn
  lambda_function_name           = var.lambda_function_name
  vpc_id                         = var.vpc_id
  private_subnets                = var.private_subnets
  nlb_cadastros_listener_arn     = var.nlb_cadastros_listener_arn
  nlb_ordem_servico_listener_arn = var.nlb_ordem_servico_listener_arn
  nlb_pagamentos_listener_arn    = var.nlb_pagamentos_listener_arn
}
