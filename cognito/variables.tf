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

variable "cognito_domain_prefix" {
  description = "Prefixo do domínio do Cognito. Deve ser único globalmente."
  type        = string
  default     = ""
}

variable "user_pool_name" {
  description = "Nome do User Pool do Cognito (opcional, se não fornecido será usado o padrão)."
  type        = string
  default     = ""
}

variable "resource_server_identifier" {
  description = "Identificador do Resource Server (ex: mechermes)."
  type        = string
  default     = "mechermes"
}

variable "resource_server_name" {
  description = "Nome do Resource Server."
  type        = string
  default     = "Mecanica Hermes API"
}
