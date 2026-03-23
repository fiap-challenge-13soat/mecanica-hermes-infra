resource "aws_cognito_resource_server" "main" {
  identifier   = var.resource_server_identifier
  name         = var.resource_server_name
  user_pool_id = aws_cognito_user_pool.main.id

  scope {
    scope_name        = "admin"
    scope_description = "Admin access scope"
  }

  scope {
    scope_name        = "client"
    scope_description = "Client access scope"
  }
}
