# RFCs de Infraestrutura

Este documento consolida decisões técnicas relevantes (RFCs) para a infraestrutura.

## RFC-001 — Provedor de nuvem AWS

- **Status:** Aceito
- **Contexto:** necessidade de prover serviços gerenciados para rede, computação, autenticação e integração.
- **Decisão:** adotar AWS como nuvem principal.
- **Impactos:** integração nativa entre EKS, Cognito, API Gateway, Lambda, RDS e Secrets Manager.

## RFC-002 — Terraform como IaC com estado remoto

- **Status:** Aceito
- **Contexto:** múltiplos repositórios e ambientes exigem rastreabilidade e execução previsível.
- **Decisão:** usar Terraform com backend S3 e lock DynamoDB.
- **Impactos:** evita corrida de estado, padroniza deploy e rollback infra.

## RFC-003 — Estratégia de autenticação OAuth2/JWT

- **Status:** Aceito
- **Contexto:** API requer autenticação por escopos (`admin` e `client`) e integração com API Gateway.
- **Decisão:** usar AWS Cognito com flow `client_credentials` e autorizer JWT no API Gateway.
- **Impactos:** delega identidade ao Cognito e simplifica o enforcement de autenticação no edge.

## RFC-004 — API Gateway como ponto único de entrada

- **Status:** Aceito
- **Contexto:** necessidade de entrada unificada para backend no EKS e Lambda de geração de token.
- **Decisão:** usar API Gateway HTTP com integração VPC Link (NLB interno) + Lambda proxy.
- **Impactos:** separa preocupações de borda, autenticação e roteamento.

## RFC-005 — Banco relacional PostgreSQL gerenciado

- **Status:** Aceito
- **Contexto:** a aplicação exige integridade transacional, relacionamento entre entidades e consultas estruturadas.
- **Decisão:** adotar Amazon RDS PostgreSQL como banco principal.
- **Impactos:** reduz esforço operacional de administração de banco e mantém compatibilidade total com o stack .NET + EF Core/Npgsql.

## RFC-006 — Banco privado na VPC

- **Status:** Aceito
- **Contexto:** a API e a Lambda operam dentro da infraestrutura AWS e não exigem exposição pública do banco.
- **Decisão:** manter RDS privado (`publicly_accessible = false`), acessível apenas por security groups autorizados.
- **Impactos:** melhora postura de segurança e reduz superfície de ataque.

## RFC-007 — Banco relacional PostgreSQL gerenciado

- **Status:** Aceito
- **Contexto:** a aplicação exige integridade transacional, relacionamento entre entidades e consultas estruturadas.
- **Decisão:** adotar Amazon RDS PostgreSQL como banco principal.
- **Impactos:** reduz esforço operacional de administração de banco e mantém compatibilidade total com o stack .NET + EF Core/Npgsql.

## RFC-008 — Provisionamento via Terraform

- **Status:** Aceito
- **Contexto:** necessidade de consistência entre ambientes e rastreabilidade de mudanças de infraestrutura.
- **Decisão:** usar Terraform com backend remoto S3 e lock em DynamoDB.
- **Impactos:** permite execução automatizada por pipeline, versionamento e revisão de mudanças.

## RFC-009 — Banco privado na VPC

- **Status:** Aceito
- **Contexto:** a API e a Lambda operam dentro da infraestrutura AWS e não exigem exposição pública do banco.
- **Decisão:** manter RDS privado (`publicly_accessible = false`), acessível apenas por security groups autorizados.
- **Impactos:** melhora postura de segurança e reduz superfície de ataque.
