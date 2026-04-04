# Database (RDS PostgreSQL) — Guia Rápido

Referência rápida para provisionar o banco de dados RDS PostgreSQL nos ambientes HML e PRD.

## Pré-requisitos

1. Credenciais AWS configuradas.
2. Módulo `aws/` (ou `learner-lab/`) já aplicado — necessário para VPC, Security Group e DB Subnet Group.
3. Backend remoto do Terraform disponível (S3 + DynamoDB). Consulte o [README principal](../README.md).

## Deploy via GitHub Actions (recomendado)

1. No repositório `mecanica-hermes-infra`, acesse **Actions**.
2. Execute o workflow **`Database - Terraform Create`**.
3. Informe o ambiente (`hml` ou `prd`).
4. Aguarde a conclusão (~5-10 minutos).

Para destruir:

1. Execute **`Database - Terraform Destroy`**.
2. Informe o ambiente (`hml` ou `prd`).

## Deploy local (alternativo)

### 1. Configurar AWS CLI

```bash
aws configure
```

### 2. Inicializar Terraform

```bash
cd db

# HML
terraform init "-backend-config=backend-hml.hcl"

# PRD
terraform init "-backend-config=backend-prd.hcl"
```

### 3. Aplicar configuração

```bash
# HML
terraform apply -var="environment=hml"

# PRD
terraform apply -var="environment=prd"
```

### 4. Destruir (quando necessário)

```bash
terraform apply -destroy -var="environment=hml"
```

## Tempo estimado

| Fase | Tempo |
| --- | --- |
| RDS Instance | ~5-10 minutos |

## Troubleshooting rápido

- **Erro de VPC/SG não encontrado**: certifique-se de que o módulo `aws/` (ou `learner-lab/`) foi aplicado antes.
- **Timeout na criação do RDS**: processo normal, pode levar até 10 minutos. Não cancele.

## Referência

Para detalhes completos (variáveis, backend, pipeline), consulte o [README.md](./README.md).
