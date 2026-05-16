# PowerShell version of cleanup script for Windows
param(
    [Parameter(Mandatory=$true)]
    [string]$VpcId
)

$ErrorActionPreference = "Stop"
$env:AWS_PAGER = ""

Write-Host "🔍 Verificando ENIs órfãos no VPC $VpcId..." -ForegroundColor Cyan

# Buscar todas as ENIs no VPC que são do tipo Lambda
try {
    $lambdaEnis = aws ec2 describe-network-interfaces `
        --filters "Name=vpc-id,Values=$VpcId" "Name=description,Values=AWS Lambda VPC ENI*" `
        --query 'NetworkInterfaces[*].NetworkInterfaceId' `
        --output text 2>$null
    
    if ([string]::IsNullOrWhiteSpace($lambdaEnis)) {
        Write-Host "✅ Nenhuma ENI órfã da Lambda encontrada" -ForegroundColor Green
        exit 0
    }
    
    $eniArray = $lambdaEnis -split '\s+'
    $eniCount = $eniArray.Count
    Write-Host "⚠️  Encontradas $eniCount ENI(s) órfã(s) da Lambda" -ForegroundColor Yellow
    
    # Aguardar até 15 minutos para AWS limpar automaticamente
    $timeout = 900
    $elapsed = 0
    $interval = 30
    
    while ($elapsed -lt $timeout) {
        # Verificar quais ENIs ainda existem
        try {
            $remaining = aws ec2 describe-network-interfaces `
                --network-interface-ids $eniArray `
                --query 'NetworkInterfaces[*].NetworkInterfaceId' `
                --output text 2>$null
            
            if ([string]::IsNullOrWhiteSpace($remaining)) {
                Write-Host "✅ Todas as ENIs foram limpas automaticamente pela AWS!" -ForegroundColor Green
                exit 0
            }
            
            $remainingArray = $remaining -split '\s+'
            $remainingCount = $remainingArray.Count
            Write-Host "⏳ Aguardando limpeza automática... ($elapsed/$timeout segundos) - $remainingCount ENI(s) restante(s)" -ForegroundColor Yellow
        }
        catch {
            Write-Host "✅ Todas as ENIs foram limpas automaticamente pela AWS!" -ForegroundColor Green
            exit 0
        }
        
        Start-Sleep -Seconds $interval
        $elapsed += $interval
    }
    
    # Após timeout, tentar deletar manualmente as ENIs que estiverem disponíveis
    Write-Host "⚠️  Timeout atingido. Tentando deletar ENIs disponíveis manualmente..." -ForegroundColor Yellow
    
    foreach ($eni in $eniArray) {
        try {
            $status = aws ec2 describe-network-interfaces `
                --network-interface-ids $eni `
                --query 'NetworkInterfaces[0].Status' `
                --output text 2>$null
            
            if ($status -eq "available") {
                Write-Host "🗑️  Deletando ENI $eni (status: available)..." -ForegroundColor Cyan
                try {
                    aws ec2 delete-network-interface --network-interface-id $eni 2>$null
                    Write-Host "✅ ENI $eni deletada" -ForegroundColor Green
                }
                catch {
                    Write-Host "⚠️  Falha ao deletar ENI $eni" -ForegroundColor Yellow
                }
            }
            elseif ([string]::IsNullOrWhiteSpace($status)) {
                Write-Host "✅ ENI $eni já foi deletada" -ForegroundColor Green
            }
            else {
                Write-Host "⏭️  ENI $eni ainda está em uso (status: $status) - pulando" -ForegroundColor Yellow
            }
        }
        catch {
            Write-Host "✅ ENI $eni já foi deletada" -ForegroundColor Green
        }
    }
    
    Write-Host "✅ Cleanup de ENIs concluído" -ForegroundColor Green
    exit 0
}
catch {
    Write-Host "❌ Erro ao executar cleanup: $_" -ForegroundColor Red
    exit 1
}
