# Learner Lab AWS — Guia Rápido

Referência rápida para provisionar a infraestrutura base (VPC + EKS) em ambientes AWS Academy Learner Lab.

## Pré-requisitos

1. Credenciais AWS do Learner Lab configuradas.
2. ID da conta AWS disponível (necessário para ARNs das roles `LabRole` e `voclabs`).
3. Backend remoto do Terraform disponível (S3 + DynamoDB). Consulte o [README principal](../README.md).

## Deploy via GitHub Actions (recomendado)

### 1. Configurar GitHub Secrets

| Secret | Descrição |
| --- | --- |
| `AWS_ACCESS_KEY_ID` | Chave de acesso AWS do Learner Lab |
| `AWS_SECRET_ACCESS_KEY` | Chave secreta AWS do Learner Lab |
| `AWS_SESSION_TOKEN` | Token de sessão AWS do Learner Lab |
| `AWS_ACCOUNT_ID` | ID numérico da conta AWS |

### 2. Disparar a Pipeline

1. Acesse **Actions** no repositório `mecanica-hermes-infra`.
2. Execute o workflow **`Learner Lab AWS - Terraform Create`**.
3. Aguarde a conclusão (~15-25 minutos).

Para destruir:

1. Execute **`Learner Lab AWS - Terraform Destroy`**.

> **Atenção:** destrua os recursos dependentes (K8s, Database, API Gateway) antes de destruir a infra base.

## Deploy local (alternativo)

### 1. Configurar AWS CLI

```bash
aws configure
```

### 2. Exportar variável da conta

```bash
export TF_VAR_aws_account_id="123456789012"
```

### 3. Inicializar e aplicar

```bash
cd learner-lab
terraform init
terraform apply
```

### 4. Destruir (quando necessário)

```bash
terraform destroy
```

## Tempo estimado

| Fase | Tempo |
| --- | --- |
| VPC e Subnets | ~2 minutos |
| EKS Cluster | ~10-15 minutos |
| Node Groups | ~5-8 minutos |
| **Total** | **~15-25 minutos** |

## Troubleshooting rápido

- **Erro de permissão IAM**: verifique se está usando as credenciais corretas do Learner Lab e se o `AWS_ACCOUNT_ID` está configurado.
- **Timeout na criação do EKS**: processo normal, pode levar até 15 minutos. Não cancele.

## Referência

Para detalhes completos (variáveis, diferenças com o módulo `aws/`, troubleshooting), consulte o [README.md](./README.md).
