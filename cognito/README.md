# Mecânica Hermes - Cognito Infrastructure

Este módulo Terraform gerencia a infraestrutura do AWS Cognito para autenticação e autorização da aplicação Mecânica Hermes.

---

## Tecnologias Utilizadas

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-232F3E?logo=amazonaws&logoColor=white)
![Amazon Cognito](https://img.shields.io/badge/Amazon%20Cognito-DD344C?logo=amazonaws&logoColor=white)
![AWS Secrets Manager](https://img.shields.io/badge/AWS%20Secrets%20Manager-DD344C?logo=amazonaws&logoColor=white)

- **Terraform** para provisionamento de infraestrutura como código (IaC)
- **AWS Cognito** para autenticação e autorização OAuth2
- **AWS Secrets Manager** para armazenamento seguro de credenciais
- **S3** para armazenamento do estado do Terraform
- **DynamoDB** para lock de estado do Terraform

---

## Recursos Gerenciados

Este módulo provisiona e gerencia os seguintes recursos do Cognito:

- **User Pool**: Pool de usuários do Cognito
- **User Pool Client**: Cliente de aplicação com suporte a `client_credentials` flow
- **Resource Server**: Servidor de recursos com scopes customizados
- **Domain**: Domínio Cognito para endpoints OAuth2
- **Secrets Manager**: Armazenamento seguro do `client_secret` e outras credenciais

### Scopes Customizados

O módulo configura dois scopes:

- `mechermes/admin`: Acesso administrativo
- `mechermes/client`: Acesso de cliente

---

## Arquitetura

```mermaid
flowchart TB
    subgraph Cognito["AWS Cognito"]
        UP["User Pool"]
        RS["Resource Server"]
        Client["App Client"]
        Domain["Cognito Domain"]
    end
    
    subgraph Secrets["AWS Secrets Manager"]
        Secret["mechermes-{env}-cognito-credentials"]
    end
    
    subgraph State["Terraform State"]
        S3["S3 Bucket"]
        DDB["DynamoDB Lock"]
    end
    
    UP --> Client
    UP --> RS
    UP --> Domain
    Client --> Secret
    
    Domain --> TokenEndpoint["OAuth2 Token Endpoint"]
    
    Lambda["Lambda Function"] --> TokenEndpoint
    Lambda --> Secret
    API["API Application"] --> TokenEndpoint
    API --> Secret
```

---

## Estrutura de Diretórios

```text
cognito/
├── modules/
│   └── cognito/
│       ├── domain.tf              # Cognito Domain
│       ├── outputs.tf             # Outputs do módulo
│       ├── resource_server.tf     # Resource Server com scopes
│       ├── secrets.tf             # AWS Secrets Manager
│       ├── user_pool.tf           # User Pool
│       ├── user_pool_client.tf    # App Client
│       └── variables.tf           # Variáveis do módulo
├── backend-hml.hcl                # Configuração de backend para HML
├── backend-prd.hcl                # Configuração de backend para PRD
├── backend.tf                     # Definição do backend S3
├── hml.tfvars.example             # Exemplo de variáveis para HML
├── main.tf                        # Invocação do módulo
├── outputs.tf                     # Outputs raiz
├── prd.tfvars.example             # Exemplo de variáveis para PRD
├── provider.tf                    # Provider AWS
└── variables.tf                   # Variáveis raiz
```

---

## Pré-requisitos

### 1. Credenciais AWS

Configure suas credenciais AWS:

```bash
aws configure
```

### 2. Backend do Terraform

Certifique-se de que o bucket S3 e a tabela DynamoDB existem:

```bash
# Criar bucket S3 (se não existir)
aws s3api create-bucket --bucket mechermes-tf-state-aws --region us-east-1

# Criar tabela DynamoDB (se não existir)
aws dynamodb create-table \
  --table-name mechermes-tf-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region us-east-1
```

---

## Configuração Inicial

### 1. Obter Informações do Cognito Existente

Antes de importar, você precisa obter as informações do Cognito configurado manualmente.

#### Listar User Pools

```bash
aws cognito-idp list-user-pools --max-results 20
```

Anote o `Id` e o `Name` do User Pool.

#### Obter Detalhes do User Pool

```bash
aws cognito-idp describe-user-pool --user-pool-id <USER_POOL_ID>
```

#### Listar Resource Servers

```bash
aws cognito-idp list-resource-servers --user-pool-id <USER_POOL_ID>
```

#### Listar User Pool Clients

```bash
aws cognito-idp list-user-pool-clients --user-pool-id <USER_POOL_ID>
```

#### Obter Domínio Cognito

```bash
aws cognito-idp describe-user-pool-domain --domain <DOMAIN_PREFIX>
```

### 2. Criar Arquivo de Variáveis

Os arquivos de variáveis já estão configurados com valores padrão. Você só precisa especificar o ambiente:

**`hml.tfvars`**:

```hcl
environment = "hml"
```

**`prd.tfvars`**:

```hcl
environment = "prd"
```

Todos os outros valores são gerados automaticamente usando o padrão `${project_name}-${environment}`:

- `cognito_domain_prefix` → `mechermes-hml` ou `mechermes-prd`
- `user_pool_name` → `mechermes-hml-userpool` ou `mechermes-prd-userpool`

---

## Importação de Recursos Existentes

**IMPORTANTE**: Para evitar a destruição dos recursos existentes, você deve importá-los para o estado do Terraform antes de executar `terraform apply`.

### 1. Inicializar Terraform

```bash
# Para HML
terraform init -backend-config=backend-hml.hcl

# Para PRD
terraform init -backend-config=backend-prd.hcl
```

### 2. Executar Terraform Plan (sem aplicar)

```bash
# Para HML
terraform plan -var-file=hml.tfvars

# Para PRD
terraform plan -var-file=prd.tfvars
```

Você verá que o Terraform quer criar todos os recursos. Isso é esperado antes da importação.

### 3. Importar Recursos

Execute os comandos de importação abaixo, substituindo os valores pelos IDs reais:

#### a) Importar User Pool

```bash
terraform import -var-file=hml.tfvars \
  module.cognito.aws_cognito_user_pool.main \
  <USER_POOL_ID>
```

**Exemplo**:

```bash
terraform import -var-file=hml.tfvars \
  module.cognito.aws_cognito_user_pool.main \
  us-east-1_ABC123DEF
```

#### b) Importar Resource Server

```bash
terraform import -var-file=hml.tfvars \
  module.cognito.aws_cognito_resource_server.main \
  <USER_POOL_ID>|<RESOURCE_SERVER_IDENTIFIER>
```

**Exemplo**:

```bash
terraform import -var-file=hml.tfvars \
  module.cognito.aws_cognito_resource_server.main \
  us-east-1_ABC123DEF|mechermes
```

#### c) Importar User Pool Client

```bash
terraform import -var-file=hml.tfvars \
  module.cognito.aws_cognito_user_pool_client.main \
  <USER_POOL_ID>/<CLIENT_ID>
```

**Exemplo**:

```bash
terraform import -var-file=hml.tfvars \
  module.cognito.aws_cognito_user_pool_client.main \
  us-east-1_ABC123DEF/1a2b3c4d5e6f7g8h9i0j
```

#### d) Importar Cognito Domain

```bash
terraform import -var-file=hml.tfvars \
  module.cognito.aws_cognito_user_pool_domain.main \
  <COGNITO_DOMAIN_PREFIX>
```

**Exemplo**:

```bash
terraform import -var-file=hml.tfvars \
  module.cognito.aws_cognito_user_pool_domain.main \
  mechermes-hml
```

#### e) Criar Secret no Secrets Manager (não precisa importar)

O secret será criado pelo Terraform. Se já existir um secret com credenciais, você pode:

- Renomear o secret existente
- Ou importá-lo:

```bash
terraform import -var-file=hml.tfvars \
  module.cognito.aws_secretsmanager_secret.cognito_credentials \
  <SECRET_ARN>
```

### 4. Verificar Importação

Após importar todos os recursos, execute novamente o plan:

```bash
terraform plan -var-file=hml.tfvars
```

**Resultado esperado**: O Terraform deve mostrar que não há mudanças a serem feitas, ou apenas mudanças pequenas (como tags ou descrições). **NÃO deve mostrar destruição e recriação de recursos**.

---

## Execução

### Aplicar Configuração

Após a importação bem-sucedida:

```bash
# Para HML
terraform apply -var-file=hml.tfvars

# Para PRD
terraform apply -var-file=prd.tfvars
```

### Validação

```bash
# Formatar código
terraform fmt -recursive

# Validar sintaxe
terraform validate

# Ver plano de execução
terraform plan -var-file=hml.tfvars
```

---

## Deploy via GitHub Actions

Este módulo pode ser implantado automaticamente através de GitHub Actions workflows.

### Workflows Disponíveis

O projeto possui 2 workflows unificados:

- **Cognito - Terraform Create**: Cria/atualiza infraestrutura Cognito (selecione HML ou PRD)
- **Cognito - Terraform Destroy**: Destrói infraestrutura Cognito (selecione HML ou PRD)

### Configuração de Secrets e Variáveis

Configure os seguintes secrets/variáveis no GitHub:

#### Secrets (environment `aws`)

| Secret | Descrição |
| ------ | --------- |
| `AWS_ACCESS_KEY_ID` | AWS Access Key ID |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Access Key |
| `AWS_SESSION_TOKEN` | AWS Session Token (se aplicável) |

#### Variáveis

| Variável | Descrição | Valor Padrão |
| -------- | --------- | ------------ |
| `AWS_DEFAULT_REGION` | Região AWS | `us-east-1` |

### Arquivos de Variáveis

Os arquivos `hml.tfvars` e `prd.tfvars` já estão configurados no repositório com valores simplificados:

```hcl
environment = "hml"  # ou "prd"
```

Não é necessário configurar mais nada. Todos os valores são gerados automaticamente.

### Executando Workflows

1. Navegue até **Actions** no repositório GitHub
2. Selecione o workflow desejado (ex: "Cognito - Terraform Create")
3. Clique em **Run workflow**
4. Selecione a branch (geralmente `main`)
5. **Selecione o ambiente** (`hml` ou `prd`)
6. Clique em **Run workflow** novamente

### Ordem de Execução Recomendada

#### Primeira Implantação (com recursos existentes)

1. **Preparação Local**:
   - Configure os arquivos `hml.tfvars` e `prd.tfvars`
   - Execute importação local dos recursos existentes
   - Verifique com `terraform plan` que não há destruição
   - Faça commit dos arquivos `.tfvars`

2. **Deploy via GitHub Actions**:
   - Execute workflow "Cognito - Terraform Create" selecionando ambiente `hml`
   - Verifique os logs para garantir sucesso
   - Execute workflow "Cognito - Terraform Create" selecionando ambiente `prd`

#### Atualizações Subsequentes

Após a primeira implantação, você pode usar os workflows diretamente para aplicar mudanças:

1. Edite os arquivos Terraform conforme necessário
2. Faça commit e push para o repositório
3. Execute o workflow correspondente ao ambiente desejado

### Vantagens do GitHub Actions

- ✅ **Infraestrutura centralizada**: Não depende de ambiente local
- ✅ **Auditoria**: Todas as execuções ficam registradas
- ✅ **Segurança**: Secrets gerenciados pelo GitHub
- ✅ **Automação**: Backend S3/DynamoDB criado automaticamente se necessário
- ✅ **Consistência**: Mesma versão do Terraform em todas as execuções
- ✅ **Simplicidade**: Apenas um workflow para ambos ambientes (HML e PRD)

---

## Outputs

Após o apply, o Terraform fornecerá os seguintes outputs (não sensíveis):

| Output | Descrição |
| ------ | --------- |
| `cognito_user_pool_id` | ID do User Pool |
| `cognito_user_pool_arn` | ARN do User Pool |
| `cognito_client_id` | ID do App Client |
| `cognito_domain` | Prefixo do domínio Cognito |
| `cognito_token_endpoint` | URL do endpoint OAuth2 token |
| `cognito_scopes` | Lista de scopes disponíveis |
| `cognito_secret_arn` | ARN do secret no Secrets Manager |
| `cognito_secret_name` | Nome do secret no Secrets Manager |

### Visualizar Outputs

```bash
terraform output
```

---

## Consumo por Aplicações

### Lambda Function

A Lambda deve:

1. Obter o nome do secret via output do Terraform (`cognito_secret_name`)
2. Usar AWS SDK para ler o secret do Secrets Manager
3. Extrair `client_id` e `client_secret` do JSON
4. Fazer requisição POST para o `token_endpoint` com `grant_type=client_credentials`

**Variáveis de ambiente sugeridas**:

```bash
COGNITO_SECRET_ID=mechermes-hml-cognito-credentials
```

> **Observação:** o repositório `mecanica-hermes-lambda` cria/atualiza um secret adicional (`mechermes-{env}-cognito-client-secret`) que consolida credenciais do Cognito e senha do banco para o fluxo específico da Lambda de token.

### API Application

Similar à Lambda, a API pode:

1. Ler configuração do Cognito via variáveis de ambiente
2. Validar tokens JWT recebidos usando o `user_pool_id`

---

## Gestão de Secrets

### Visualizar Secret

```bash
aws secretsmanager get-secret-value \
  --secret-id mechermes-hml-cognito-credentials \
  --query SecretString \
  --output text | jq
```

### Rotação Manual (se necessário)

Se precisar rotacionar o `client_secret`:

1. Gere um novo secret no Cognito Console
2. Atualize o secret no Secrets Manager
3. Reinicie aplicações que usam o secret

---

## Segurança

- **client_secret** nunca é exposto em outputs do Terraform
- Credenciais são armazenadas no AWS Secrets Manager com criptografia
- Recovery window de 7 dias para secrets deletados
- User Pool configurado com `prevent_destroy` para evitar destruição acidental
- Todos os recursos são tagueados para auditoria

---

## Troubleshooting

### Erro: Resource already exists

Se você receber um erro dizendo que o recurso já existe, execute a importação correspondente conforme documentado acima.

### Erro: Domain already exists

O domínio Cognito é globalmente único. Certifique-se de usar o mesmo prefixo do domínio existente.

### Erro: Client secret not accessible

Verifique as permissões IAM da aplicação consumidora. Ela precisa de:

```json
{
  "Effect": "Allow",
  "Action": [
    "secretsmanager:GetSecretValue",
    "secretsmanager:DescribeSecret"
  ],
  "Resource": [
    "arn:aws:secretsmanager:us-east-1:*:secret:mechermes-*-cognito-credentials-*",
    "arn:aws:secretsmanager:us-east-1:*:secret:mechermes-*-cognito-client-secret-*"
  ]
}
```

### Terraform plan mostra recriação de recursos

Se após a importação o Terraform ainda quer recriar recursos, compare os atributos:

```bash
terraform show
```

Compare com os valores reais no AWS Console. Ajuste as variáveis conforme necessário.

---

## Manutenção

### Adicionar novo scope

1. Edite `modules/cognito/resource_server.tf`
2. Adicione um novo bloco `scope`
3. Atualize `user_pool_client.tf` para incluir o novo scope em `allowed_oauth_scopes`
4. Execute `terraform apply`

### Adicionar novo ambiente

1. Crie `backend-{env}.hcl` com a configuração do backend
2. Crie `{env}.tfvars` com as variáveis do ambiente
3. Siga os passos de importação para o novo ambiente

---

## Referências

- [AWS Cognito Terraform Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool)
- [OAuth 2.0 Client Credentials Flow](https://oauth.net/2/grant-types/client-credentials/)
- [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/)

---

## Suporte

Em caso de problemas:

1. Verifique os logs do Terraform com `TF_LOG=DEBUG terraform apply`
2. Consulte a documentação do provider AWS
3. Verifique se as credenciais AWS têm as permissões necessárias
