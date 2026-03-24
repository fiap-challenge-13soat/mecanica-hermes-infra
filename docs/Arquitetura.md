# Arquitetura da Infraestrutura

Este documento descreve a arquitetura provisionada pelo repositório `mecanica-hermes-infra`.

## Escopo do repositório

Este repositório contém três módulos Terraform:

- `aws/`: VPC, sub-redes, EKS e security groups base.
- `cognito/`: User Pool, App Client, Resource Server, domínio e secret do Cognito.
- `api-gateway/`: API Gateway HTTP, autorizer JWT Cognito e integração com Lambda/NLB.

## Visão arquitetural

```mermaid
flowchart LR
  subgraph InfraRepo["Repo: mecanica-hermes-infra"]
    AWS["Módulo aws/"]
    COG["Módulo cognito/"]
    APIGW["Módulo api-gateway/"]
  end

  subgraph AWSCloud["AWS"]
    VPC["VPC + Subnets"]
    EKS["EKS"]
    SG["Security Groups"]
    COGNITO["Cognito"]
    SM["Secrets Manager"]
    GATEWAY["API Gateway HTTP"]
    VPCLINK["VPC Link"]
  end

  subgraph ExternalRepos["Outros repositórios"]
    DB["mecanica-hermes-db\nRDS PostgreSQL"]
    K8S["mecanica-hermes-k8s\nAPI no cluster"]
    LAMBDA["mecanica-hermes-lambda\nCognito Token Lambda"]
  end

  AWS --> VPC
  AWS --> EKS
  AWS --> SG

  COG --> COGNITO
  COG --> SM

  APIGW --> GATEWAY
  APIGW --> VPCLINK

  VPC --> DB
  EKS --> K8S
  SM --> LAMBDA
  COGNITO --> LAMBDA
  GATEWAY --> LAMBDA
  VPCLINK --> K8S
```

## Dependências e ordem de provisionamento

1. Infra base (`aws/`): VPC + EKS + Security Groups.
2. Autenticação (`cognito/`): recursos OAuth2/JWT.
3. Banco (`mecanica-hermes-db`): RDS em sub-redes privadas.
4. Aplicação (`mecanica-hermes-k8s`): API e observabilidade no cluster.
5. Lambda (`mecanica-hermes-lambda`): geração de token para clientes.
6. Entrada unificada (`api-gateway/`): roteamento público com autenticação JWT.

## Estado e locking do Terraform

Todos os módulos usam backend remoto S3 com lock em DynamoDB:

- Bucket: `mechermes-tf-state-aws`
- Tabela de lock: `mechermes-tf-locks`
