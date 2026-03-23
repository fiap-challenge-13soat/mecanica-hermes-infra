variable "project_name" {
  description = "Nome do projeto."
  type        = string
}

variable "environment" {
  description = "Nome do ambiente (hml ou prd)."
  type        = string
}

variable "cognito_domain_prefix" {
  description = "Prefixo do domínio do Cognito."
  type        = string
}

variable "user_pool_name" {
  description = "Nome do User Pool do Cognito."
  type        = string
}

variable "resource_server_identifier" {
  description = "Identificador do Resource Server."
  type        = string
}

variable "resource_server_name" {
  description = "Nome do Resource Server."
  type        = string
}
