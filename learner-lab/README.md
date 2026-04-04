# Módulo `learner-lab/` — Infraestrutura Base Learner Lab (VPC + EKS)

Este módulo Terraform provisiona a infraestrutura base necessária para a Mecânica Hermes em ambientes AWS criados via Learner Lab.

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-232F3E?logo=amazonaws&logoColor=white)

> **Nota:** este módulo é uma alternativa ao módulo `aws/` quando você está trabalhando em um ambiente Learner Lab da AWS Academy, que possui restrições específicas de IAM.

## Recursos provisionados

- **VPC** com sub-redes públicas, privadas e de banco de dados
- **NAT Gateway** para acesso à internet das sub-redes privadas
- **EKS Cluster** (Kubernetes 1.34) com Node Groups (`t3.small`, 2–6 nós)
- **Security Groups** para comunicação entre EKS, RDS e Lambda
- Configuração específica para roles `LabRole` e `voclabs` do AWS Academy

## Pré-requisitos

Consulte o [`README.md`](../README.md) principal do repositório para configuração de credenciais e backend remoto.

## Variáveis necessárias

| Variável | Descrição |
| --- | --- |
| `project_name` | Nome base para todos os recursos (exemplo: `mechermes`) |
| `aws_account_id` | ID numérico da conta AWS (obrigatório para ARNs das roles do Learner Lab) |

## Secrets (GitHub Actions)

| Secret | Descrição |
| --- | --- |
| `AWS_ACCOUNT_ID` | ID da conta AWS, usado para construir ARNs das roles `LabRole` e `voclabs` |
| `AWS_ACCESS_KEY_ID` | Chave de acesso AWS |
| `AWS_SECRET_ACCESS_KEY` | Chave secreta AWS |
| `AWS_SESSION_TOKEN` | Token de sessão AWS |

## Execução via GitHub Actions

1. Acesse **Actions** no repositório `mecanica-hermes-infra`
2. Execute o workflow **`Learner Lab AWS - Terraform Create`**
3. Aguarde a conclusão (~15-25 minutos)

## Execução local

Para passos rápidos de deploy local e via GitHub Actions, consulte o [QUICK-START.md](./QUICK-START.md).

## Diferenças em relação ao módulo `aws/`

O módulo Learner Lab ajusta roles e permissões para compatibilidade com ambientes AWS Academy:

- Usa roles `LabRole` e `voclabs` em vez de criar novas roles IAM
- Requer `aws_account_id` explícito para construir ARNs
- Configuração de OIDC limitada conforme restrições do Learner Lab

## Destruir recursos

1. Via GitHub Actions: execute o workflow **`Learner Lab AWS - Terraform Destroy`**.
2. Via CLI: consulte o [QUICK-START.md](./QUICK-START.md#4-destruir-quando-necessário).

> **Atenção:** destrua os recursos dependentes (K8s, Database, API Gateway) antes de destruir a infra base.

## Troubleshooting

### Erro de permissão IAM

**Causa:** Learner Lab possui restrições de permissões.

**Solução:** verifique se está usando as credenciais corretas do Learner Lab e se o `AWS_ACCOUNT_ID` está configurado.

### Timeout na criação do EKS

**Causa:** processo normal, pode levar até 15 minutos.

**Solução:** aguarde a conclusão. Não cancele o processo.

## Referências

- [AWS Academy Learner Lab](https://aws.amazon.com/pt/training/awsacademy/)
- [README principal](../README.md)
