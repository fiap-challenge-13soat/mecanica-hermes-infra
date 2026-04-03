# Arquitetura da Infraestrutura

Este documento descreve a arquitetura provisionada pelo repositório `mecanica-hermes-infra`.

## Escopo do repositório

Este repositório contém cinco módulos Terraform:

- `aws/`: VPC, sub-redes, EKS e security groups base (conta admin).
- `learner-lab/`: mesma infraestrutura base, adaptada para AWS Academy Learner Lab.
- `cognito/`: User Pool, App Client, Resource Server, domínio e secret do Cognito.
- `db/`: RDS PostgreSQL para ambientes HML e PRD.
- `api-gateway/`: API Gateway HTTP, autorizer JWT Cognito e integração com Lambda/NLB.

## Visão arquitetural

```mermaid
flowchart LR
  subgraph InfraRepo["mecanica-hermes-infra"]
    AWS["Módulo aws/"]
    LL["Módulo learner-lab/"]
    COG["Módulo cognito/"]
    DBTF["Módulo db/"]
    APIGW["Módulo api-gateway/"]
  end

  subgraph AWSCloud["AWS"]
    VPC["VPC + Subnets"]
    EKS["EKS"]
    SG["Security Groups"]
    COGNITO["Cognito"]
    SM["Secrets Manager"]
    RDS["RDS PostgreSQL"]
    GATEWAY["API Gateway HTTP"]
    VPCLINK["VPC Link"]
  end

  subgraph ExternalRepos["Outros repositórios"]
    K8S["mecanica-hermes-k8s\nAPI no cluster"]
    LAMBDA["mecanica-hermes-lambda\nCognito Token Lambda"]
  end

  AWS --> VPC
  AWS --> EKS
  AWS --> SG
  LL --> VPC
  LL --> EKS
  LL --> SG

  COG --> COGNITO
  COG --> SM

  DBTF --> RDS
  VPC --> DBTF
  SG --> DBTF

  APIGW --> GATEWAY
  APIGW --> VPCLINK

  EKS --> K8S
  RDS --> K8S
  RDS --> LAMBDA
  SM --> LAMBDA
  COGNITO --> LAMBDA
  GATEWAY --> COGNITO
  GATEWAY --> LAMBDA
  GATEWAY --> VPCLINK
  VPCLINK --> K8S
```

## Dependências e ordem de provisionamento

1. Infra base (`aws/`): VPC + EKS + Security Groups.
2. Autenticação (`cognito/`): recursos OAuth2/JWT.
3. Banco (`db/`): RDS PostgreSQL em sub-redes privadas.
4. Aplicação (`mecanica-hermes-k8s`): API e observabilidade no cluster.
5. Lambda (`mecanica-hermes-lambda`): geração de token para clientes.
6. Entrada unificada (`api-gateway/`): roteamento público com autenticação JWT.

## Estado e locking do Terraform

Todos os módulos usam backend remoto S3 com lock em DynamoDB:

- Bucket: `mechermes-tf-state-aws`
- Tabela de lock: `mechermes-tf-locks`
