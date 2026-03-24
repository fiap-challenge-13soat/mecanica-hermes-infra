# Scripts de Cleanup AWS

## cleanup-orphan-enis.sh / cleanup-orphan-enis.ps1

Scripts para limpar ENIs (Elastic Network Interfaces) órfãs deixadas por Lambda functions com VPC.

### Problema

Quando Lambda functions com configuração VPC são deletadas, as ENIs gerenciadas pela AWS (tipo `ela-attach`) não são deletadas imediatamente. A AWS as limpa automaticamente após 5-15 minutos, mas isso pode causar falhas no `terraform destroy` ao tentar deletar subnets e security groups.

### Solução

Estes scripts:
1. Identificam ENIs órfãas da Lambda no VPC
2. Aguardam até 15 minutos para limpeza automática pela AWS
3. Tentam deletar manualmente ENIs que estiverem com status `available`
4. Permitem que o `terraform destroy` continue sem erros

### Uso Manual

**Linux/macOS (Bash):**
```bash
chmod +x cleanup-orphan-enis.sh
./cleanup-orphan-enis.sh vpc-xxxxxxxxxxxxx
```

**Windows (PowerShell):**
```powershell
.\cleanup-orphan-enis.ps1 -VpcId vpc-xxxxxxxxxxxxx
```

### Uso Automático via Terraform

O arquivo `cleanup-enis.tf` integra o script automaticamente no processo de destroy:

```hcl
resource "null_resource" "cleanup_lambda_enis" {
  provisioner "local-exec" {
    when    = destroy
    command = "bash ${path.module}/scripts/cleanup-orphan-enis.sh ${self.triggers.vpc_id}"
  }
}
```

Quando você executar `terraform destroy`, o script será executado automaticamente antes de tentar destruir as subnets.

### Requisitos

- AWS CLI configurado com credenciais válidas
- Permissões IAM:
  - `ec2:DescribeNetworkInterfaces`
  - `ec2:DeleteNetworkInterface`
- Bash (Linux/macOS) ou PowerShell (Windows)

### Saída Esperada

```
🔍 Verificando ENIs órfãos no VPC vpc-xxxxx...
⚠️  Encontradas 3 ENI(s) órfã(s) da Lambda
⏳ Aguardando limpeza automática... (0/900 segundos) - 3 ENI(s) restante(s)
⏳ Aguardando limpeza automática... (30/900 segundos) - 3 ENI(s) restante(s)
...
✅ Todas as ENIs foram limpas automaticamente pela AWS!
```

### Notas

- ENIs do tipo `ela-attach` (Elastic Lambda Attachment) não podem ser detachadas manualmente
- O script aguarda até 15 minutos para limpeza automática antes de tentar deletar manualmente
- Se uma ENI ainda estiver `in-use`, o script a pula e continua
- O script usa `on_failure = continue` no Terraform para não bloquear o destroy em caso de erro
