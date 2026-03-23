variable "project_name" {
  description = "Nome do projeto."
  type        = string
  default     = "mechermes"
}

variable "environment" {
  description = "Nome do ambiente (hml ou prd)."
  type        = string
  default     = "hml"

  validation {
    condition     = contains(["hml", "prd"], var.environment)
    error_message = "O ambiente deve ser 'hml' ou 'prd'."
  }
}

variable "cognito_user_pool_arn" {
  description = "ARN do Cognito User Pool para autenticação."
  type        = string
}

variable "cognito_app_client_id" {
  description = "ID do App Client do Cognito User Pool para JWT audience."
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN da função Lambda para integração."
  type        = string
}

variable "lambda_function_name" {
  description = "Nome da função Lambda."
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde os recursos estão hospedados."
  type        = string
}

variable "private_subnets" {
  description = "IDs das subnets privadas para VPC Link."
  type        = list(string)
}

variable "api_backend_sg_id" {
  description = "Security Group ID do backend da API no EKS."
  type        = string
}

variable "nlb_listener_arn" {
  description = "ARN do listener do NLB criado pelo Kubernetes LoadBalancer Service."
  type        = string
}

variable "nlb_target_port" {
  description = "Porta do target do NLB (porta do serviço K8s)."
  type        = number
  default     = 80
}
