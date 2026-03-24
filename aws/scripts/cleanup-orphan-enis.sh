#!/bin/bash
set -e

VPC_ID=$1

if [ -z "$VPC_ID" ]; then
  echo "Usage: $0 <vpc-id>"
  exit 1
fi

echo "🔍 Verificando ENIs órfãos no VPC $VPC_ID..."

# Buscar todas as ENIs no VPC que são do tipo Lambda
LAMBDA_ENIS=$(aws ec2 describe-network-interfaces \
  --filters "Name=vpc-id,Values=$VPC_ID" \
            "Name=description,Values=AWS Lambda VPC ENI*" \
  --query 'NetworkInterfaces[*].NetworkInterfaceId' \
  --output text 2>/dev/null || echo "")

if [ -z "$LAMBDA_ENIS" ]; then
  echo "✅ Nenhuma ENI órfã da Lambda encontrada"
  exit 0
fi

ENI_COUNT=$(echo $LAMBDA_ENIS | wc -w)
echo "⚠️  Encontradas $ENI_COUNT ENI(s) órfã(s) da Lambda"

# Aguardar até 15 minutos para AWS limpar automaticamente
TIMEOUT=900
ELAPSED=0
INTERVAL=30

while [ $ELAPSED -lt $TIMEOUT ]; do
  # Verificar quais ENIs ainda existem
  REMAINING=$(aws ec2 describe-network-interfaces \
    --network-interface-ids $LAMBDA_ENIS \
    --query 'NetworkInterfaces[*].NetworkInterfaceId' \
    --output text 2>/dev/null || echo "")
  
  if [ -z "$REMAINING" ]; then
    echo "✅ Todas as ENIs foram limpas automaticamente pela AWS!"
    exit 0
  fi
  
  REMAINING_COUNT=$(echo $REMAINING | wc -w)
  echo "⏳ Aguardando limpeza automática... ($ELAPSED/$TIMEOUT segundos) - $REMAINING_COUNT ENI(s) restante(s)"
  
  sleep $INTERVAL
  ELAPSED=$((ELAPSED + INTERVAL))
done

# Após timeout, tentar deletar manualmente as ENIs que estiverem disponíveis
echo "⚠️  Timeout atingido. Tentando deletar ENIs disponíveis manualmente..."

for ENI in $LAMBDA_ENIS; do
  STATUS=$(aws ec2 describe-network-interfaces \
    --network-interface-ids $ENI \
    --query 'NetworkInterfaces[0].Status' \
    --output text 2>/dev/null || echo "not-found")
  
  if [ "$STATUS" = "available" ]; then
    echo "🗑️  Deletando ENI $ENI (status: available)..."
    aws ec2 delete-network-interface --network-interface-id $ENI 2>/dev/null && \
      echo "✅ ENI $ENI deletada" || \
      echo "⚠️  Falha ao deletar ENI $ENI"
  elif [ "$STATUS" = "not-found" ]; then
    echo "✅ ENI $ENI já foi deletada"
  else
    echo "⏭️  ENI $ENI ainda está em uso (status: $STATUS) - pulando"
  fi
done

echo "✅ Cleanup de ENIs concluído"
exit 0
