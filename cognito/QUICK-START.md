# Cognito — Guia Rápido

Referência rápida para provisionar o módulo de infraestrutura do Cognito.

## Pré-requisitos

1. Credenciais AWS configuradas.
2. Backend remoto do Terraform disponível (S3 + DynamoDB).
3. Se estiver adotando recursos já existentes, ter os IDs do User Pool/Client/Domain.

## Deploy via GitHub Actions (recomendado)

1. No repositório `mecanica-hermes-infra`, acesse **Actions**.
2. Execute o workflow **`Cognito - Terraform Create`**.
3. Informe o `environment` (`hml` ou `prd`).
4. Aguarde a conclusão e valide os outputs no resumo da execução.

Para destruir:

1. Execute **`Cognito - Terraform Destroy`**.
2. Informe o `environment` (`hml` ou `prd`).

## Deploy local (alternativo)

### 1. Arquivo de variáveis

```bash
# HML
cp hml.tfvars.example hml.tfvars

# PRD
cp prd.tfvars.example prd.tfvars
```

### 2. Inicializar Terraform

```bash
# HML
terraform init -backend-config=backend-hml.hcl

# PRD
terraform init -backend-config=backend-prd.hcl
```

### 3. Importar recursos existentes (quando aplicável)

Se os recursos Cognito já existirem, faça a importação manual antes do `apply`.
Use os comandos documentados no [README.md](./README.md) (seção **Importação de Recursos Existentes**).

### 4. Planejar e aplicar

```bash
# HML
terraform plan -var-file=hml.tfvars
terraform apply -var-file=hml.tfvars

# PRD
terraform plan -var-file=prd.tfvars
terraform apply -var-file=prd.tfvars
```

## Outputs principais

```bash
terraform output
```

- `cognito_token_endpoint`
- `cognito_client_id`
- `cognito_secret_name`

## Consumo pelas aplicações

As aplicações consumidoras devem:

1. Ler o secret do Secrets Manager usando `cognito_secret_name`.
2. Extrair `client_id` e `client_secret`.
3. Solicitar token no endpoint OAuth2 (`client_credentials`).

Exemplo:

```bash
COGNITO_SECRET_ID=mechermes-hml-cognito-credentials
```

## Troubleshooting rápido

- **Terraform quer recriar recursos**: valide se todos os recursos existentes foram importados.
- **Erro de domínio já existente**: confirme o prefixo de domínio em uso no Cognito.
- **Acesso negado ao Secrets Manager**: ajuste a policy IAM para `secretsmanager:GetSecretValue`.

## Referência

Para detalhes completos, consulte o [README.md](./README.md).
