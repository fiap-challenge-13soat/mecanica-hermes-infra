# Mecânica Hermes - Infra Kubernetes

Este repositório é responsável por criar o cluster para realizar o deploy do projeto.

---

## Arquitetura dos Projetos de Infra

Nossa infraestrutura para disponibilizar um ambiente completo e funcional é composta por três passos sequenciais que são executados em diferentes repositórios:

1. Mecânica Hermes - Infra Kubernetes (Este projeto)
2. [Mecânica Hermes - Infra Database](https://github.com/fiap-challenge-13soat/mecanica-hermes-db)
3. [Mecânica Hermes - Deploy Kubernetes](https://github.com/fiap-challenge-13soat/mecanica-hermes-k8s)

## Execução pela Pipeline

**Configure as Secrets abaixo no repositório.**

---

| Variável              |
| --------------------- |
| AWS_ACCESS_KEY_ID     |
| AWS_SECRET_ACCESS_KEY |
| AWS_SESSION_TOKEN     |
| AWS_DEFAULT_REGION    |

---

### Create Environment

---
Dispare a Action Trigger manual de acordo com o seu ambiente:

- **Learning Lab:** `Learning Lab - Terraform Create`.
- **AWS com Usuário Admin:** `AWS Admin - Terraform Create`.

---

### Destroy Environment

---
Dispare a Action Trigger manual de acordo com o seu ambiente:

- **Learning Lab:** `Learning Lab - Terraform Destroy`.
- **AWS com Usuário Admin:** `AWS Admin - Terraform Destroy`.

---

> **Atenção!**
>
> Caso tenha sido realizado o deploy do ambiente K8s, então será necessário realizar o destroy K8s antes de destruir o ambiente via Terraform, caso contrário, alguns recursos de Load Balance e Security Groups impedirão a destruição via Terraform.
---

## Execução Local

Abordaremos os passos para realizar a criação de infraestrutura em ambiente AWS partindo do seu computador.

---

### Configuração da AWS

Realize o comando abaixo e forneça suas credenciais.

```bash
aws configure
```

---

### Criação do bucket para o terraform state

Caso ainda não exista, crie o bucket destinado a armazenar o arquivo do terraform state.

```bash
aws s3api create-bucket --bucket mechermes-tf-state --region us-east-1
```

---

### Criação da tabela no DynamoDB para o terraform lock

Caso ainda não exista, crie a tabela destinado a controlar o lock do terraform.

```bash
aws dynamodb create-table --table-name mechermes-tf-locks --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --region us-east-1 || echo "Tabela já existe"
```

---

### Deploy do Terraform no AWS Learning Lab

Confira o [README.md](./learning-lab/README.md) com maiores detalhes para este deploy.

---

### Deploy do Terraform no AWS com usuário admin

Confira o [README.md](./aws/README.md) com maiores detalhes para este deploy.
