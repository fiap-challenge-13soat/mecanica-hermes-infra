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
