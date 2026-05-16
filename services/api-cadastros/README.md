# Módulo `db/` — Database (RDS PostgreSQL)

Este módulo Terraform provisiona instâncias Amazon RDS PostgreSQL para os ambientes de homologação (`hml`) e produção (`prd`), reutilizando recursos de rede criados pelo módulo `aws/` ou `learner-lab/`.

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-232F3E?logo=amazonaws&logoColor=white)
![Amazon RDS](https://img.shields.io/badge/Amazon%20RDS-527FFF?logo=amazonrds&logoColor=white)

## Recursos provisionados

- **Amazon RDS PostgreSQL 17.6** — instância `db.t4g.micro` com 10 GB de storage
- **Criptografia de storage** habilitada (`storage_encrypted = true`)
- **Backup automático** com retenção de 7 dias (`backup_retention_period = 7`)
- **Snapshot final** ao destruir (`skip_final_snapshot = false`)
- **Acesso privado** — sem exposição pública (`publicly_accessible = false`)

## Pré-requisitos

O módulo `aws/` (ou `learner-lab/`) deve ter sido aplicado previamente, pois este módulo consome via `data sources`:

- **VPC** (`mechermes-vpc`)
- **Security Group** (`mechermes-sg`)
- **DB Subnet Group** (`mechermes-vpc`)

## Variáveis necessárias

| Variável | Descrição | Default |
| --- | --- | --- |
| `project_name` | Nome base para todos os recursos | `mechermes` |
| `environment` | Nome do ambiente (`hml` ou `prd`) | `hml` |

## Secrets (GitHub Actions)

| Secret | Descrição |
| --- | --- |
| `AWS_ACCESS_KEY_ID` | Chave de acesso AWS |
| `AWS_SECRET_ACCESS_KEY` | Chave secreta AWS |
| `AWS_SESSION_TOKEN` | Token de sessão AWS |

## Execução via GitHub Actions

1. Acesse **Actions** no repositório `mecanica-hermes-infra`
2. Execute o workflow **`Database - Terraform Create`**
3. Informe o ambiente (`hml` ou `prd`)
4. Aguarde a conclusão (~5-10 minutos)

## Execução local

Para passos rápidos de deploy local e via GitHub Actions, consulte o [QUICK-START.md](./QUICK-START.md).

## Destruir recursos

1. Via GitHub Actions: execute o workflow **`Database - Terraform Destroy`** (informe `hml` ou `prd`).
2. Via CLI: consulte o [QUICK-START.md](./QUICK-START.md#4-destruir-quando-necessário).

> **Atenção:** destrua o API Gateway antes de destruir o banco de dados.

## Troubleshooting

### Erro de VPC/SG não encontrado

**Causa:** módulo `aws/` (ou `learner-lab/`) não foi aplicado antes.

**Solução:** aplique o módulo de infraestrutura base primeiro.

### Timeout na criação do RDS

**Causa:** processo normal, pode levar até 10 minutos.

**Solução:** aguarde a conclusão. Não cancele o processo.

## Referências

- [Terraform AWS RDS Module](https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest)
- [Amazon RDS PostgreSQL](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html)
- [README principal](../README.md)
