# Módulo `aws/` — Infraestrutura Base (VPC + EKS)

Este módulo realiza o provisionamento da infraestrutura base da Mecânica Hermes na AWS, incluindo VPC, subnets, cluster EKS e security groups compartilhados.

## Requisitos

Configure os requisitos conforme descrito no [`README.md`](../README.md) da raiz do projeto.

## Configurações

### Variáveis

Edite o arquivo `variables.tf` com os seus dados do projeto.

| Variável      | Descrição                                                                       |
| ------------- | ------------------------------------------------------------------------------- |
| project_name  | Nome do projeto, será utilizado como base para nomear todos os demais recursos. |

---

### Backend

Edite o arquivo `backend.tf` alterando o nome do bucket de destino e da tabela DynamoDB de destino para os mesmos valores criados durante a configuração dos requisitos.

---

## Execução pela Pipeline

Os workflows relacionados a este módulo são executados no repositório `mecanica-hermes-infra`:

- `AWS - Terraform Create`
- `AWS - Terraform Destroy`
- `Learning Lab AWS - Terraform Create`
- `Learning Lab AWS - Terraform Destroy`

> Os workflows de `learning-lab` exigem também o secret `AWS_ACCOUNT_ID`.

---

## Execução Local

- **O primeiro passo é iniciar o seu ambiente através do comando**

```bash
terraform init
```

- **Em seguida, realize o apply do seu script**

```bash
terraform apply
```

---

### Observações

> O processo de criação pode demorar de 15 a 25 minutos.

---

### Correção de Problemas

> Este processo foi amplamente testado, mas caso ocorra algum erro durante a sua execução, sugerimos abrir o ambiente no VSCode e solicitar ajuda ao Copilot.
