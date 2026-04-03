# AWS Admin — Guia Rápido

Referência rápida para provisionar a infraestrutura base (VPC + EKS) usando uma conta AWS com usuário admin.

## Pré-requisitos

1. Credenciais AWS configuradas (usuário com permissões de admin).
2. Backend remoto do Terraform disponível (S3 + DynamoDB). Consulte o [README principal](../README.md).

## Deploy via GitHub Actions (recomendado)

### 1. Configurar GitHub Secrets

| Secret | Descrição |
| --- | --- |
| `AWS_ACCESS_KEY_ID` | Chave de acesso AWS |
| `AWS_SECRET_ACCESS_KEY` | Chave secreta AWS |
| `AWS_SESSION_TOKEN` | Token de sessão AWS |

### 2. Disparar a Pipeline

1. No repositório `mecanica-hermes-infra`, acesse **Actions**.
2. Execute o workflow **`AWS - Terraform Create`**.
3. Aguarde a conclusão (~15-25 minutos).

Para destruir:

1. Execute **`AWS - Terraform Destroy`**.

> **Atenção:** destrua os recursos dependentes (K8s, Database, API Gateway) antes de destruir a infra base.

## Deploy local (alternativo)

### 1. Configurar AWS CLI

```bash
aws configure
```

### 2. Inicializar Terraform

```bash
cd aws
terraform init
```

### 3. Aplicar configuração

```bash
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

- **Timeout na criação do EKS**: processo normal, pode levar até 15 minutos. Não cancele.
- **Erro de permissão IAM**: verifique se o usuário tem permissões de admin.

## Referência

Para detalhes completos (variáveis, backend, correção de problemas), consulte o [README.md](./README.md).
