resource "aws_apigatewayv2_route" "lambda_post" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "POST /auth/generate-token"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"

  authorization_type = "NONE"
}

resource "aws_apigatewayv2_route" "api_backend" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.api_backend.id}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito.id
}

resource "aws_apigatewayv2_route" "health_check" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /health"
  target    = "integrations/${aws_apigatewayv2_integration.api_backend.id}"

  authorization_type = "NONE"
}

resource "aws_apigatewayv2_route" "healthz_live" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /healthz/live"
  target    = "integrations/${aws_apigatewayv2_integration.api_backend.id}"

  authorization_type = "NONE"
}

resource "aws_apigatewayv2_route" "healthz_ready" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /healthz/ready"
  target    = "integrations/${aws_apigatewayv2_integration.api_backend.id}"

  authorization_type = "NONE"
}
