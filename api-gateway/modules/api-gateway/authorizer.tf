resource "aws_apigatewayv2_authorizer" "cognito" {
  api_id           = aws_apigatewayv2_api.main.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "${var.project_name}-${var.environment}-cognito-authorizer"

  jwt_configuration {
    audience = [var.cognito_app_client_id]
    issuer   = "https://cognito-idp.${data.aws_region.current.name}.amazonaws.com/${element(split("/", var.cognito_user_pool_arn), length(split("/", var.cognito_user_pool_arn)) - 1)}"
  }
}
