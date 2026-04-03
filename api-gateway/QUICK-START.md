# API Gateway — Guia Rápido

Referência rápida para provisionar o API Gateway HTTP nos ambientes HML e PRD.

## Pré-requisitos

1. Credenciais AWS configuradas.
2. Módulo `aws/` (ou `learner-lab/`) já aplicado.
3. Módulo `cognito/` já aplicado.
4. Lambda Function deployada (via repositório `mecanica-hermes-lambda`).
5. API Backend deployado no K8s com serviço NLB (via repositório `mecanica-hermes-k8s`).
6. Backend remoto do Terraform disponível (S3 + DynamoDB). Consulte o [README principal](../README.md).

## Deploy via GitHub Actions (recomendado)

### 1. Configurar GitHub Secrets

| Secret | Descrição |
| --- | --- |
| `AWS_ACCESS_KEY_ID` | Chave de acesso AWS |
| `AWS_SECRET_ACCESS_KEY` | Chave secreta AWS |
| `AWS_SESSION_TOKEN` | Token de sessão AWS |

### 2. Disparar a Pipeline

1. Acesse **Actions** no repositório `mecanica-hermes-infra`.
2. Execute o workflow **`API Gateway - Terraform Create`**.
3. Informe o ambiente (`hml` ou `prd`).
4. Aguarde a conclusão (~8-10 minutos).

A URL do API Gateway estará disponível no **Summary** da pipeline.

Para destruir:

1. Execute **`API Gateway - Terraform Destroy`** (informe `hml` ou `prd`).

> **Atenção:** o API Gateway deve ser o primeiro recurso a ser destruído ao desfazer o ambiente.

## Deploy local (alternativo)

### 1. Configurar AWS CLI

```bash
aws configure
```

### 2. Inicializar e aplicar

```bash
cd api-gateway

# HML
terraform init -backend-config=backend-hml.hcl
terraform plan -var-file=hml.tfvars
terraform apply -var-file=hml.tfvars

# PRD
terraform init -backend-config=backend-prd.hcl
terraform plan -var-file=prd.tfvars
terraform apply -var-file=prd.tfvars
```

### 3. Obter URL do API Gateway

```bash
terraform output stage_invoke_url
```

### 4. Destruir (quando necessário)

```bash
terraform destroy -var-file=hml.tfvars
```

## Testando o API Gateway

```bash
export API_GATEWAY_URL="<sua-url-aqui>"

# Health check
curl "$API_GATEWAY_URL/health"

# Gerar token (envia para o e-mail do cliente)
curl -X POST "$API_GATEWAY_URL/auth/generate-token" \
  -H "Content-Type: application/json" \
  -d '{"cpf": "51125363061"}'

# Acessar API com token JWT
curl "$API_GATEWAY_URL/api/ordens-de-servico" \
  -H "Authorization: Bearer $ACCESS_TOKEN"

# Sem token — deve retornar 401
curl "$API_GATEWAY_URL/api/ordens-de-servico"
```

## Tempo estimado

| Fase | Tempo |
| --- | --- |
| API Gateway + rotas | ~2 minutos |
| VPC Link | ~5-8 minutos |
| **Total** | **~8-10 minutos** |

## Troubleshooting rápido

- **VPC Link not available**: aguarde ~5-10 minutos, a criação do VPC Link é o passo mais demorado.
- **Unauthorized**: token JWT inválido ou expirado. Gere um novo via `POST /auth/generate-token`.
- **Could not connect to NLB**: verifique se o serviço K8s está rodando (`kubectl get svc -n mecanica-hermes-hml`).

## Referência

Para detalhes completos (arquitetura, rotas, segurança, troubleshooting), consulte o [README.md](./README.md).
