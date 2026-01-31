# Mecânica Hermes - Infra Kubernetes

Este repositório é responsável por criar o cluster para realizar o deploy do projeto.

---

## Tecnologias Utilizadas

---

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-232F3E?logo=amazonaws&logoColor=white)
![Amazon VPC](https://img.shields.io/badge/Amazon%20VPC-232F3E?logo=amazonaws&logoColor=white)
![EKS](https://img.shields.io/badge/EKS-Kubernetes-FF9900?logo=amazon-eks&logoColor=white)
![Amazon S3](https://img.shields.io/badge/Amazon%20S3-569A31?logo=amazons3&logoColor=white)
![Amazon DynamoDB](https://img.shields.io/badge/Amazon%20DynamoDB-4053D6?logo=amazondynamodb&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-CI/CD-2088FF?logo=githubactions&logoColor=white)

- **Terraform** para provisionamento de infraestrutura como código (IaC)
- **AWS** como provedor de nuvem
- **VPC, Subnets e Security Groups** para rede e segurança
- **Amazon EKS** para o cluster Kubernetes
- **S3** para armazenamento do estado do Terraform
- **DynamoDB** para lock de estado do Terraform
- **GitHub Actions** para execução da pipeline.

---

## Arquitetura dos Projetos de Infra

Nossa infraestrutura para disponibilizar um ambiente completo e funcional é composta por três passos sequenciais que são executados em diferentes repositórios:

1. Mecânica Hermes - Infra Kubernetes (Este projeto)
2. [Mecânica Hermes - Infra Database](https://github.com/fiap-challenge-13soat/mecanica-hermes-db)
3. [Mecânica Hermes - Deploy Kubernetes](https://github.com/fiap-challenge-13soat/mecanica-hermes-k8s)

---

```mermaid
flowchart
  subgraph Step1["Repo: Infra Kubernetes (este projeto)"]
   TF["Terraform"]
   VPC["VPC: mechermes-vpc"]
   SG["Security Group: mechermes-sg"]
   Subnet["Subnets privadas/públicas"]
   EKS["EKS Cluster (privado)"]
   Nodes["Node Groups"]
  end

  subgraph Step2["Repo: Infra Database"]
   Data["Data sources: VPC/SG/Subnets"]
   RDS["RDS PostgreSQL (privado)"]
  end

  subgraph Step3["Conta Externa: Terraform State & Lock"]
   S3["S3: tfstate"]
   DDB["DynamoDB: tf locks"]
  end

  subgraph Step4["Repo: Deploy Kubernetes"]
   Apps["Apps publicados no Kubernetes"]
  end

  TF --> VPC
  TF --> SG
  TF --> Subnet
  TF --> EKS
  TF --> Nodes
  TF --> S3
  TF --> DDB

  VPC --> Data
  SG --> Data
  Subnet --> Data
  Data --> RDS

  EKS --> Apps
  RDS --> Apps
```

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

Para gerar nova Key e Token use o comando:

```bash
aws sts get-session-token
```

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
aws s3api create-bucket --bucket mechermes-tf-state-aws --region us-east-1
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
