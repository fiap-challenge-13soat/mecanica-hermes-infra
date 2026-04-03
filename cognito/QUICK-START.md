# Cognito — Guia Rápido

Referência rápida para provisionar a infraestrutura do AWS Cognito nos ambientes HML e PRD.

## Pré-requisitos

1. Credenciais AWS configuradas.
2. Backend remoto do Terraform disponível (S3 + DynamoDB). Consulte o [README principal](../README.md).

## Deploy via GitHub Actions (recomendado)

### 1. Configurar GitHub Secrets

| Secret | Descrição |
| --- | --- |
| `AWS_ACCESS_KEY_ID` | Chave de acesso AWS |
| `AWS_SECRET_ACCESS_KEY` | Chave secreta AWS |
| `AWS_SESSION_TOKEN` | Token de sessão AWS |

### 2. Disparar a Pipeline

1. Acesse **Actions** no repositório `mecanica-hermes-infra`.
2. Execute o workflow **`Cognito - Terraform Create`**.
3. Informe o ambiente (`hml` ou `prd`).
4. Aguarde a conclusão e valide os outputs no resumo da execução.

Para destruir:

1. Execute **`Cognito - Terraform Destroy`** (informe `hml` ou `prd`).

> **Atenção:** destrua o API Gateway antes de destruir o Cognito.

## Deploy local (alternativo)

### 1. Configurar AWS CLI

```bash
aws configure
```

### 2. Inicializar e aplicar

```bash
cd cognito

# HML
terraform init -backend-config=backend-hml.hcl
terraform plan -var-file=hml.tfvars
terraform apply -var-file=hml.tfvars

# PRD
terraform init -backend-config=backend-prd.hcl
terraform plan -var-file=prd.tfvars
terraform apply -var-file=prd.tfvars
```

### 3. Verificar outputs

```bash
terraform output
```

### 4. Destruir (quando necessário)

```bash
terraform destroy -var-file=hml.tfvars
```

## Tempo estimado

| Fase | Tempo |
| --- | --- |
| Cognito User Pool + Client | ~2 minutos |
| Secrets Manager | ~1 minuto |
| **Total** | **~3-5 minutos** |

## Troubleshooting rápido

- **Terraform quer recriar recursos**: valide se todos os recursos existentes foram importados com `terraform import`.
- **Erro de domínio já existente**: confirme o prefixo de domínio em uso no Cognito.
- **Acesso negado ao Secrets Manager**: ajuste a policy IAM para `secretsmanager:GetSecretValue`.

## Referência

Para detalhes completos (arquitetura, outputs, consumo por aplicações, troubleshooting), consulte o [README.md](./README.md).
