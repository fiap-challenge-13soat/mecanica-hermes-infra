resource "aws_cognito_user_pool_client" "main" {
  name         = "${var.project_name}-${var.environment}-client"
  user_pool_id = aws_cognito_user_pool.main.id

  generate_secret = true

  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  allowed_oauth_flows = [
    "client_credentials"
  ]

  allowed_oauth_scopes = [
    "${var.resource_server_identifier}/admin",
    "${var.resource_server_identifier}/client"
  ]

  allowed_oauth_flows_user_pool_client = true

  prevent_user_existence_errors = "ENABLED"

  supported_identity_providers = []

  depends_on = [aws_cognito_resource_server.main]
}
