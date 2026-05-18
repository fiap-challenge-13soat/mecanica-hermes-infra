# ── Auth (Lambda) ─────────────────────────────────────────────────────────────

resource "aws_apigatewayv2_route" "lambda_post" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "POST /auth/generate-token"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"

  authorization_type = "NONE"
}

# ── Scalar API docs (public) ──────────────────────────────────────────────────
# /scalar/{proxy+} and /openapi/{proxy+} route to cadastros (fully working: spec URL matches).
# /scalar/ordem-servico and /scalar/pagamentos are more specific and take precedence,
# rewiring to their respective services via dedicated integrations (path rewritten to /scalar/v1).
# Limitation: Scalar's HTML embeds spec-url="/openapi/v1.json" for all three UIs, which routes
# to cadastros' spec. To fix, configure each service's MapOpenApi/MapScalarApiReference with a
# service-specific path and add matching /openapi/<service>/{proxy+} routes here.

resource "aws_apigatewayv2_route" "scalar_cadastros" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /cadastros/scalar/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.cadastros.id}"

  authorization_type = "NONE"
}

resource "aws_apigatewayv2_route" "openapi_cadastros" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /cadastros/openapi/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.cadastros.id}"

  authorization_type = "NONE"
}

resource "aws_apigatewayv2_route" "scalar_ordem_servico" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /ordem-servico/scalar/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.ordem_servico.id}"

  authorization_type = "NONE"
}

resource "aws_apigatewayv2_route" "openapi_ordem_servico" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /ordem-servico/openapi/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.ordem_servico.id}"

  authorization_type = "NONE"
}

resource "aws_apigatewayv2_route" "scalar_pagamentos" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /pagamentos/scalar/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.pagamentos.id}"

  authorization_type = "NONE"
}

resource "aws_apigatewayv2_route" "openapi_pagamentos" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /pagamentos/openapi/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.pagamentos.id}"

  authorization_type = "NONE"
}

# ── api-cadastros ─────────────────────────────────────────────────────────────

resource "aws_apigatewayv2_route" "clientes" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /api/clientes"
  target    = "integrations/${aws_apigatewayv2_integration.cadastros.id}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito.id
}

resource "aws_apigatewayv2_route" "clientes_proxy" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /api/clientes/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.cadastros.id}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito.id
}

resource "aws_apigatewayv2_route" "produtos" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /api/produtos"
  target    = "integrations/${aws_apigatewayv2_integration.cadastros.id}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito.id
}

resource "aws_apigatewayv2_route" "produtos_proxy" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /api/produtos/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.cadastros.id}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito.id
}

resource "aws_apigatewayv2_route" "notificacoes" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /api/notificacoes"
  target    = "integrations/${aws_apigatewayv2_integration.cadastros.id}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito.id
}

resource "aws_apigatewayv2_route" "notificacoes_proxy" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /api/notificacoes/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.cadastros.id}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito.id
}

resource "aws_apigatewayv2_route" "servicos" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /api/servicos"
  target    = "integrations/${aws_apigatewayv2_integration.cadastros.id}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito.id
}

resource "aws_apigatewayv2_route" "servicos_proxy" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /api/servicos/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.cadastros.id}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito.id
}

resource "aws_apigatewayv2_route" "webhooks_orcamentos" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /api/webhooks/orcamentos"
  target    = "integrations/${aws_apigatewayv2_integration.cadastros.id}"

  authorization_type = "NONE"
}

resource "aws_apigatewayv2_route" "webhooks_orcamentos_proxy" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /api/webhooks/orcamentos/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.cadastros.id}"

  authorization_type = "NONE"
}

resource "aws_apigatewayv2_route" "cadastros_options" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "OPTIONS /api/clientes/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.cadastros.id}"

  authorization_type = "NONE" #
}

resource "aws_apigatewayv2_route" "produtos_options" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "OPTIONS /api/produtos/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.cadastros.id}"

  authorization_type = "NONE"
}

resource "aws_apigatewayv2_route" "notificacoes_options" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "OPTIONS /api/notificacoes/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.cadastros.id}"

  authorization_type = "NONE"
}

resource "aws_apigatewayv2_route" "servicos_options" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "OPTIONS /api/servicos/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.cadastros.id}"

  authorization_type = "NONE"
}

# ── api-ordem-servico ─────────────────────────────────────────────────────────

resource "aws_apigatewayv2_route" "ordens_de_servico" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /api/ordens-de-servico"
  target    = "integrations/${aws_apigatewayv2_integration.ordem_servico.id}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito.id
}

resource "aws_apigatewayv2_route" "ordens_de_servico_proxy" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /api/ordens-de-servico/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.ordem_servico.id}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito.id
}

resource "aws_apigatewayv2_route" "ordens_de_servico_options" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "OPTIONS /api/ordens-de-servico/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.ordem_servico.id}"

  authorization_type = "NONE"
}

# ── api-pagamentos ────────────────────────────────────────────────────────────

resource "aws_apigatewayv2_route" "pagamentos" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /api/pagamentos"
  target    = "integrations/${aws_apigatewayv2_integration.pagamentos.id}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito.id
}

resource "aws_apigatewayv2_route" "pagamentos_proxy" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /api/pagamentos/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.pagamentos.id}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito.id
}

resource "aws_apigatewayv2_route" "webhooks_mercadopago" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /api/webhooks/mercadopago"
  target    = "integrations/${aws_apigatewayv2_integration.pagamentos.id}"

  authorization_type = "NONE"
}

resource "aws_apigatewayv2_route" "webhooks_mercadopago_proxy" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /api/webhooks/mercadopago/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.pagamentos.id}"

  authorization_type = "NONE"
}

resource "aws_apigatewayv2_route" "pagamentos_options" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "OPTIONS /api/pagamentos/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.pagamentos.id}"

  authorization_type = "NONE"
}

# ── Health checks (no auth, routed to cadastros) ──────────────────────────────

resource "aws_apigatewayv2_route" "health_check" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /health"
  target    = "integrations/${aws_apigatewayv2_integration.cadastros.id}"

  authorization_type = "NONE"
}

resource "aws_apigatewayv2_route" "healthz_live" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /healthz/live"
  target    = "integrations/${aws_apigatewayv2_integration.cadastros.id}"

  authorization_type = "NONE"
}

resource "aws_apigatewayv2_route" "healthz_ready" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /healthz/ready"
  target    = "integrations/${aws_apigatewayv2_integration.cadastros.id}"

  authorization_type = "NONE"
}
