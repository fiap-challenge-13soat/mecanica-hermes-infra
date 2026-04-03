# Módulo `aws/` — Infraestrutura Base (VPC + EKS)

Este módulo realiza o provisionamento da infraestrutura base da Mecânica Hermes na AWS, incluindo VPC, subnets, cluster EKS e security groups compartilhados.

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-232F3E?logo=amazonaws&logoColor=white)

## Recursos provisionados

- **VPC** com sub-redes públicas, privadas e de banco de dados
- **NAT Gateway** para acesso à internet das sub-redes privadas
- **EKS Cluster** (Kubernetes 1.34) com Node Groups (`t3.small`, 2–6 nós)
- **Security Groups** para comunicação entre EKS, RDS e Lambda
- **Roles IAM** criadas automaticamente pelo módulo EKS

## Pré-requisitos

Consulte o [`README.md`](../README.md) principal do repositório para configuração de credenciais e backend remoto.

## Variáveis necessárias

| Variável | Descrição |
| --- | --- |
| `project_name` | Nome base para todos os recursos (exemplo: `mechermes`) |

## Secrets (GitHub Actions)

| Secret | Descrição |
| --- | --- |
| `AWS_ACCESS_KEY_ID` | Chave de acesso AWS |
| `AWS_SECRET_ACCESS_KEY` | Chave secreta AWS |
| `AWS_SESSION_TOKEN` | Token de sessão AWS |

## Execução via GitHub Actions

1. Acesse **Actions** no repositório `mecanica-hermes-infra`
2. Execute o workflow **`AWS - Terraform Create`**
3. Aguarde a conclusão (~15-25 minutos)

## Execução local

Para passos rápidos de deploy local e via GitHub Actions, consulte o [QUICK-START.md](./QUICK-START.md).

## Destruir recursos

1. Via GitHub Actions: execute o workflow **`AWS - Terraform Destroy`**.
2. Via CLI: consulte o [QUICK-START.md](./QUICK-START.md#4-destruir-quando-necessário).

> **Atenção:** destrua os recursos dependentes (K8s, Database, API Gateway) antes de destruir a infra base.

## Troubleshooting

### Timeout na criação do EKS

**Causa:** processo normal, pode levar até 15 minutos.

**Solução:** aguarde a conclusão. Não cancele o processo.

## Referências

- [Terraform AWS VPC Module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
- [Terraform AWS EKS Module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)
- [README principal](../README.md)
