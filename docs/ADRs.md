# ADRs de Infraestrutura

Este documento registra decisões arquiteturais permanentes.

## ADR-001 — Repositório único para módulos de infraestrutura base

- **Status:** Aceito
- **Decisão:** manter `aws/`, `cognito/` e `api-gateway/` no mesmo repositório.
- **Justificativa:** centraliza a fundação da plataforma e facilita governança de mudanças de borda.

## ADR-002 — Ambientes HML/PRD com workflows parametrizados

- **Status:** Aceito
- **Decisão:** usar `workflow_dispatch` com input `environment` (`hml`/`prd`) nos módulos aplicáveis.
- **Justificativa:** reduz duplicação e mantém o mesmo processo operacional para ambos os ambientes.

## ADR-003 — Segurança de rede privada entre API Gateway e backend

- **Status:** Aceito
- **Decisão:** integração do API Gateway com backend via `VPC Link` e NLB interno.
- **Justificativa:** evita exposição direta da API no cluster e mantém tráfego interno na VPC.

## ADR-004 — Gestão central de segredos na AWS

- **Status:** Aceito
- **Decisão:** armazenar segredos em AWS Secrets Manager e consumir via workloads (Lambda/API).
- **Justificativa:** separa segredo de configuração, melhora segurança e facilita rotação.

## ADR-005 — Um RDS por ambiente lógico

- **Status:** Aceito
- **Decisão:** manter identificadores por ambiente (`mechermes-hml-rds` e `mechermes-prd-rds`).
- **Justificativa:** isolamento operacional entre homologação e produção.

## ADR-006 — Reutilizar rede da infraestrutura base para o banco

- **Status:** Aceito
- **Decisão:** consumir VPC, DB subnet group e security group já criados pelo módulo `aws/`.
- **Justificativa:** evita duplicação de infraestrutura de rede e centraliza sua governança.

## ADR-007 — Política mínima de proteção de dados no RDS

- **Status:** Aceito
- **Decisão:** exigir criptografia de storage, backup de 7 dias e snapshot final no destroy.
- **Justificativa:** garante baseline de resiliência e recuperação sem elevar complexidade operacional.

## ADR-009 — Um RDS por ambiente lógico

- **Status:** Aceito
- **Decisão:** manter identificadores por ambiente (`mechermes-hml-rds` e `mechermes-prd-rds`).
- **Justificativa:** isolamento operacional entre homologação e produção.

## ADR-010 — Reutilizar rede da infraestrutura base

- **Status:** Aceito
- **Decisão:** consumir VPC, DB subnet group e security group já criados no repositório `mecanica-hermes-infra`.
- **Justificativa:** evita duplicação de infraestrutura de rede e centraliza sua governança.

## ADR-011 — Política mínima de proteção de dados

- **Status:** Aceito
- **Decisão:** exigir criptografia de storage, backup de 7 dias e snapshot final no destroy.
- **Justificativa:** garante baseline de resiliência e recuperação sem elevar complexidade operacional.

## ADR-012 — Consolidação do módulo de banco no repositório de infraestrutura

- **Status:** Aceito
- **Decisão:** migrar o módulo Terraform de banco de dados do repositório `mecanica-hermes-db` para este repositório como `db/`.
- **Justificativa:** reduz fragmentação de repositórios, simplifica a ordem de provisionamento e centraliza toda a infra AWS num único local.
