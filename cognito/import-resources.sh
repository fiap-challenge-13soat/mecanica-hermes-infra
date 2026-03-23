#!/bin/bash

# Script para importar recursos Cognito existentes para o Terraform
# Este script é um helper - você ainda precisa preencher os valores reais

set -e

# Configurações
ENVIRONMENT="${1:-hml}"  # hml ou prd
TFVARS_FILE="${ENVIRONMENT}.tfvars"

echo "======================================"
echo "Importação de Recursos Cognito"
echo "Ambiente: ${ENVIRONMENT}"
echo "======================================"
echo ""

# Verificar se o arquivo tfvars existe
if [ ! -f "${TFVARS_FILE}" ]; then
    echo "ERRO: Arquivo ${TFVARS_FILE} não encontrado!"
    echo "Copie ${ENVIRONMENT}.tfvars.example para ${TFVARS_FILE} e preencha os valores."
    exit 1
fi

# Solicitar informações do Cognito existente
read -p "User Pool ID (ex: us-east-1_ABC123DEF): " USER_POOL_ID
read -p "Resource Server Identifier (ex: mechermes): " RESOURCE_SERVER_IDENTIFIER
read -p "App Client ID (ex: 1a2b3c4d5e6f7g8h9i0j): " CLIENT_ID
read -p "Cognito Domain Prefix (ex: mechermes-hml): " DOMAIN_PREFIX

echo ""
echo "======================================"
echo "Resumo dos Recursos a Importar:"
echo "======================================"
echo "User Pool ID: ${USER_POOL_ID}"
echo "Resource Server: ${RESOURCE_SERVER_IDENTIFIER}"
echo "Client ID: ${CLIENT_ID}"
echo "Domain Prefix: ${DOMAIN_PREFIX}"
echo ""

read -p "Confirma a importação? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ]; then
    echo "Importação cancelada."
    exit 0
fi

echo ""
echo "======================================"
echo "Iniciando Importação..."
echo "======================================"

# 1. Importar User Pool
echo ""
echo "[1/4] Importando User Pool..."
terraform import -var-file="${TFVARS_FILE}" \
    module.cognito.aws_cognito_user_pool.main \
    "${USER_POOL_ID}" || echo "AVISO: User Pool pode já estar importado."

# 2. Importar Resource Server
echo ""
echo "[2/4] Importando Resource Server..."
terraform import -var-file="${TFVARS_FILE}" \
    module.cognito.aws_cognito_resource_server.main \
    "${USER_POOL_ID}|${RESOURCE_SERVER_IDENTIFIER}" || echo "AVISO: Resource Server pode já estar importado."

# 3. Importar User Pool Client
echo ""
echo "[3/4] Importando User Pool Client..."
terraform import -var-file="${TFVARS_FILE}" \
    module.cognito.aws_cognito_user_pool_client.main \
    "${USER_POOL_ID}/${CLIENT_ID}" || echo "AVISO: Client pode já estar importado."

# 4. Importar Cognito Domain
echo ""
echo "[4/4] Importando Cognito Domain..."
terraform import -var-file="${TFVARS_FILE}" \
    module.cognito.aws_cognito_user_pool_domain.main \
    "${DOMAIN_PREFIX}" || echo "AVISO: Domain pode já estar importado."

echo ""
echo "======================================"
echo "Importação Concluída!"
echo "======================================"
echo ""
echo "Próximos passos:"
echo "1. Execute: terraform plan -var-file=${TFVARS_FILE}"
echo "2. Verifique que não há destruição de recursos"
echo "3. Execute: terraform apply -var-file=${TFVARS_FILE}"
echo ""
