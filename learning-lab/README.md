# Learning Lab AWS — Infraestrutura Base

Este módulo Terraform provisiona a infraestrutura base necessária para a Mecânica Hermes em ambientes AWS criados via Learning Lab.

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-232F3E?logo=amazonaws&logoColor=white)

## Escopo

O módulo provisiona:

- VPC com sub-redes públicas, privadas e de banco de dados
- EKS cluster com node groups
- Security groups para comunicação entre componentes
- Configuração específica para roles `LabRole` e `voclabs` do AWS Academy

> **Nota:** este módulo é uma alternativa ao módulo `aws/` quando você está trabalhando em um ambiente Learning Lab da AWS Academy, que possui restrições específicas de IAM.

## Pré-requisitos

Consulte o [`README.md`](../README.md) principal do repositório para configuração de credenciais e backend remoto.

## Variáveis necessárias

| Variável | Descrição |
| --- | --- |
| `project_name` | Nome base para todos os recursos (exemplo: `mechermes`) |
| `aws_account_id` | ID numérico da conta AWS (obrigatório para ARNs das roles do Learning Lab) |

## Secrets (GitHub Actions)

| Secret | Descrição |
| --- | --- |
| `AWS_ACCOUNT_ID` | ID da conta AWS, usado para construir ARNs das roles `LabRole` e `voclabs` |
| `AWS_ACCESS_KEY_ID` | Chave de acesso AWS |
| `AWS_SECRET_ACCESS_KEY` | Chave secreta AWS |
| `AWS_SESSION_TOKEN` | Token de sessão AWS |

## Execução via GitHub Actions

1. Acesse **Actions** no repositório `mecanica-hermes-infra`
2. Execute o workflow **`Learning Lab AWS - Terraform Create`**
3. Aguarde a conclusão (~15-25 minutos)

## Execução local

### 1. Configurar AWS CLI

```bash
aws configure
```

### 2. Exportar variável de ambiente

```bash
export TF_VAR_aws_account_id="123456789012"
```

### 3. Inicializar Terraform

```bash
cd learning-lab
terraform init
```

### 4. Aplicar configuração

```bash
terraform apply
```

## Tempo estimado de provisionamento

- **VPC e Subnets**: ~2 minutos
- **EKS Cluster**: ~10-15 minutos
- **Node Groups**: ~5-8 minutos
- **Total**: ~15-25 minutos

## Diferenças em relação ao módulo `aws/`

O módulo Learning Lab ajusta roles e permissões para compatibilidade com ambientes AWS Academy:

- Usa roles `LabRole` e `voclabs` em vez de criar novas roles IAM
- Requer `aws_account_id` explícito para construir ARNs
- Configuração de OIDC limitada conforme restrições do Learning Lab

## Destruir recursos

Via GitHub Actions:

1. Execute o workflow **`Learning Lab AWS - Terraform Destroy`**

Via CLI:

```bash
terraform destroy
```

## Troubleshooting

### Erro de permissão IAM

**Causa:** Learning Lab possui restrições de permissões.

**Solução:** verifique se está usando as credenciais corretas do Learning Lab e se o `AWS_ACCOUNT_ID` está configurado.

### Timeout na criação do EKS

**Causa:** processo normal, pode levar até 15 minutos.

**Solução:** aguarde a conclusão. Não cancele o processo.

## Referências

- [AWS Academy Learning Lab](https://aws.amazon.com/training/digital/aws-academy/)
- [README principal](../README.md)
