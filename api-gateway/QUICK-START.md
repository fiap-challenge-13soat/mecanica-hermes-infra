# API Gateway - Quick Start Guide

Este guia rápido demonstra como fazer o deploy do API Gateway em minutos usando GitHub Actions.

---

## Pré-requisitos

Antes de iniciar, certifique-se de que os seguintes recursos já foram criados:

- ✅ VPC e Subnets (via `aws/` ou `learning-lab/`)
- ✅ EKS Cluster (via `aws/` ou `learning-lab/`)
- ✅ Cognito User Pool (via `cognito/`)
- ✅ Lambda Function (via repositório `mecanica-hermes-lambda`)
- ✅ API Backend deployado no K8s (via repositório `mecanica-hermes-k8s`)

---

## Deploy via GitHub Actions (Recomendado)

### 1. Configurar GitHub Secrets

No repositório `mecanica-hermes-infra`, configure as secrets no GitHub:

**Settings → Secrets and variables → Actions → New repository secret**

| Secret | Valor |
|--------|-------|
| `AWS_ACCESS_KEY_ID` | Sua chave de acesso AWS |
| `AWS_SECRET_ACCESS_KEY` | Sua chave secreta AWS |
| `AWS_SESSION_TOKEN` | Seu token de sessão AWS |

### 2. Configurar Environment Variable

**Settings → Secrets and variables → Actions → Variables**

| Variable | Valor |
|----------|-------|
| `AWS_DEFAULT_REGION` | `us-east-1` |

### 3. Disparar a Pipeline

1. Acesse a aba **Actions** no GitHub
2. Selecione o workflow:
   - **HML**: `API Gateway HML - Terraform Create`
   - **PRD**: `API Gateway PRD - Terraform Create`
3. Clique em **Run workflow**
4. Aguarde a conclusão (~5-10 minutos)

### 4. Obter URL do API Gateway

Após o deploy, a URL do API Gateway estará disponível no **Summary** da pipeline.

Exemplo:
```
https://abc123xyz.execute-api.us-east-1.amazonaws.com
```

---

## Deploy Manual (Alternativo)

### 1. Configurar AWS CLI

```bash
aws configure
```

### 2. Descobrir Valores de Recursos

```bash
# VPC ID
export VPC_ID=$(aws ec2 describe-vpcs \
  --filters "Name=tag:Name,Values=mechermes-vpc" \
  --query "Vpcs[0].VpcId" \
  --output text)

# Subnets Privadas
export PRIVATE_SUBNETS=$(aws ec2 describe-subnets \
  --filters "Name=tag:Name,Values=mechermes-vpc-private-*" \
  --query "Subnets[*].SubnetId" \
  --output json)

# Security Group
export API_BACKEND_SG=$(aws ec2 describe-security-groups \
  --filters "Name=tag:Name,Values=mechermes-sg" \
  --query "SecurityGroups[0].GroupId" \
  --output text)

# Cognito ARN (HML)
export COGNITO_ARN=$(aws cognito-idp list-user-pools --max-results 60 \
  --query "UserPools[?Name=='mechermes-hml-userpool'].Arn | [0]" \
  --output text)

# Lambda ARN (HML)
export LAMBDA_ARN=$(aws lambda get-function \
  --function-name mechermes-hml-cognito-token-lambda \
  --query "Configuration.FunctionArn" \
  --output text)
```

### 3. Criar arquivo de variáveis

```bash
cd api-gateway

cat > hml.tfvars <<EOF
project_name          = "mechermes"
environment           = "hml"
cognito_user_pool_arn = "$COGNITO_ARN"
lambda_function_arn   = "$LAMBDA_ARN"
lambda_function_name  = "mechermes-hml-cognito-token-lambda"
vpc_id                = "$VPC_ID"
private_subnets       = $PRIVATE_SUBNETS
api_backend_sg_id     = "$API_BACKEND_SG"
nlb_target_port       = 80
EOF
```

### 4. Inicializar e Aplicar Terraform

```bash
# Inicializar
terraform init -backend-config=backend-hml.hcl

# Planejar
terraform plan -var-file=hml.tfvars

# Aplicar
terraform apply -var-file=hml.tfvars -auto-approve
```

### 5. Obter URL do API Gateway

```bash
terraform output stage_invoke_url
```

---

## Testando o API Gateway

### 1. Teste de Conectividade

```bash
export API_GATEWAY_URL="<sua-url-aqui>"

# Health check
curl "$API_GATEWAY_URL/health"

# Deve retornar: {"status":"Healthy"}
```

### 2. Gerar Token de Acesso

```bash
# Gerar token
TOKEN_RESPONSE=$(curl -X POST "$API_GATEWAY_URL/auth/generate-token" \
  -H "Content-Type: application/json" \
  -d '{"cpf": "51125363061"}')

echo $TOKEN_RESPONSE | jq

# Extrair token
export ACCESS_TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.accessToken')
```

### 3. Acessar API Backend com Autenticação

```bash
# Listar ordens de serviço
curl "$API_GATEWAY_URL/api/v1/ordens-de-servico" \
  -H "Authorization: Bearer $ACCESS_TOKEN" | jq

# Deve retornar a lista de ordens de serviço
```

### 4. Testar Autenticação (Deve Falhar)

```bash
# Tentar acessar sem token
curl "$API_GATEWAY_URL/api/v1/ordens-de-servico"

# Deve retornar: {"message":"Unauthorized"}
```

---

## Tempo de Deploy Estimado

| Fase | Tempo Estimado |
|------|---------------|
| Terraform Init | ~30 segundos |
| Resource Discovery | ~1 minuto |
| API Gateway Creation | ~1 minuto |
| VPC Link Creation | **~5-8 minutos** ⏰ |
| Route Configuration | ~30 segundos |
| **Total** | **~8-10 minutos** |

> **Nota**: A criação do VPC Link é o passo mais demorado.

---

## Destruir Recursos

### Via GitHub Actions

1. Acesse a aba **Actions**
2. Selecione o workflow:
   - **HML**: `API Gateway HML - Terraform Destroy`
   - **PRD**: `API Gateway PRD - Terraform Destroy`
3. Clique em **Run workflow**

### Via CLI

```bash
cd api-gateway
terraform destroy -var-file=hml.tfvars -auto-approve
```

---

## Troubleshooting Rápido

### Erro: "VPC Link is not available"

**Causa**: VPC Link ainda está sendo criado

**Solução**: Aguarde ~5-10 minutos e tente novamente

### Erro: "Unauthorized" ao acessar API

**Causa**: Token inválido ou expirado

**Solução**: Gere um novo token via `POST /auth/generate-token`

### Erro: "Could not connect to NLB"

**Causa**: Service K8s ainda não criou o NLB

**Solução**: 
1. Verifique se o serviço K8s está rodando: `kubectl get svc -n mecanica-hermes-hml`
2. Aguarde o NLB ser criado (pode levar ~2-3 minutos)

---

## Próximos Passos

1. ✅ Configurar monitoramento no CloudWatch
2. ✅ Configurar alertas de 4xx/5xx errors
3. ✅ Configurar custom domain (opcional)
4. ✅ Configurar WAF para proteção adicional (opcional)
5. ✅ Configurar throttling personalizado por rota (opcional)

---

## Recursos Úteis

- [README completo](./README.md) - Documentação detalhada
- [AWS API Gateway Docs](https://docs.aws.amazon.com/apigateway/)
- [VPC Link Troubleshooting](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-vpc-links.html#http-api-vpc-link-troubleshooting)
