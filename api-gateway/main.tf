module "api_gateway" {
  source = "./modules/api-gateway"

  project_name          = var.project_name
  environment           = var.environment
  cognito_user_pool_arn = var.cognito_user_pool_arn
  cognito_app_client_id = var.cognito_app_client_id
  lambda_function_arn   = var.lambda_function_arn
  lambda_function_name  = var.lambda_function_name
  vpc_id                = var.vpc_id
  private_subnets       = var.private_subnets
  api_backend_sg_id     = var.api_backend_sg_id
  nlb_listener_arn      = var.nlb_listener_arn
  nlb_target_port       = var.nlb_target_port
}
