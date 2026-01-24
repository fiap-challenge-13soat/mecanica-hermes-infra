# Mecânica Hermes - Infra Kubernetes

Este projeto é responsável por criar o ambiente Kubernetes para realizar o deploy do projeto.

---

## Arquitetura dos Projetos de Infra

Nossa infraestrutura para disponibilizar um ambiente completo e funcional é composta por três passos sequenciais que são executados em diferentes projetos:

1. Mecânica Hermes - Infra Kubernetes (Este projeto)
2. Mecânica Hermes - Infra Database
3. Mecânica Hermes - Deploy Kubernetes

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
Dispare a Action Trigguer manual de acordo com o seu ambiente:

- **Learning Lab:** `Terraform Create - Learning Lab`.
- **AWS com Usuário Admin:** `Terraform Create - AWS Admin`.

---

### Destroy Environment

---
Dispare a Action Trigguer manual de acordo com o seu ambiente:

- **Learning Lab:** `Terraform Destroy - Learning Lab`.
- **AWS com Usuário Admin:** `Terraform Destroy - AWS Admin`.

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

## Deploy do Terraform no AWS Learning Lab

Confira o [README.md](./learning-lab/README.md) com maiores detalhes para este deploy.

## Deploy do Terraform no AWS com usuário admin

Confira o [README.md](./aws/README.md) com maiores detalhes para este deploy.

## Kubectl para todas as pastas

```bash
aws eks update-kubeconfig --name mechermes-eks
```

```bash
kubectl apply -f .\namespace.yaml
```

```bash
kubectl apply -R -f .
```

```bash
kubectl get svc -n mecanica-hermes
```
