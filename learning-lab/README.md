# Deploy do Terraform no AWS Learning Lab

Este módulo realiza o deploy do ambiente necessário para uso da Mecânica Hermes em um ambiente AWS Cloud criado via Learning Lab.

## Requisitos

Configure os requisitos conforme descrito no [`README.md`](../README.md) da raiz do projeto.

## Configurações

### Variáveis

| Variável      | Descrição                                                                       |
| ------------- | ------------------------------------------------------------------------------- |
| project_name  | Nome do projeto, será utilizado como base para nomear todos os demais recursos. |

### Secrets (GitHub Actions)

O `aws_account_id` é injetado automaticamente via GitHub Secret `AWS_ACCOUNT_ID` e utilizado para construir os ARNs das roles `LabRole` e `voclabs`.

| Secret         | Descrição                                                              |
| -------------- | ---------------------------------------------------------------------- |
| AWS_ACCOUNT_ID | ID numérico da conta AWS. Usado para montar os ARNs das roles do EKS.  |

#### Para execução local, exporte a variável antes de rodar o Terraform

```bash
export TF_VAR_aws_account_id="SEU_ACCOUNT_ID"
```

---

### Backend

Edite o arquivo `backend.tf` alterando o nome do bucket de destino e da tabela DynamoDB de destino para os mesmos valores criados durante a configuração dos requisitos.

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
