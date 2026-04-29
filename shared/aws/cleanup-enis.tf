# Cleanup automático de ENIs órfãs da Lambda antes do destroy
# Este recurso garante que ENIs gerenciadas pela Lambda sejam limpas
# antes de tentar destruir subnets e security groups

resource "null_resource" "cleanup_lambda_enis" {
  # Trigger sempre que o VPC ID mudar
  triggers = {
    vpc_id     = module.vpc.vpc_id
    script_sha = filesha256("${path.module}/scripts/cleanup-orphan-enis.sh")
  }

  # Executar cleanup durante o destroy, ANTES de destruir VPC/subnets
  provisioner "local-exec" {
    when        = destroy
    command     = "bash ${path.module}/scripts/cleanup-orphan-enis.sh ${self.triggers.vpc_id}"
    on_failure  = continue
    interpreter = ["bash", "-c"]
  }

  # Garantir que o cleanup rode antes de destruir recursos de rede
  depends_on = [
    module.vpc
  ]
}

# Forçar dependência: VPC só pode ser destruída após cleanup de ENIs
resource "null_resource" "vpc_destroy_dependency" {
  triggers = {
    cleanup_id = null_resource.cleanup_lambda_enis.id
  }

  depends_on = [
    null_resource.cleanup_lambda_enis,
    module.vpc
  ]
}
