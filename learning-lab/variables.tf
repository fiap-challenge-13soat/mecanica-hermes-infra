variable "project_name" {
  description = "Nome do projeto."
  type        = string
  default     = "mechermes"
}

variable "lab_role_arn" {
  description = "ARN da role permitida pelo AWS Learning Lab (usada pelo EKS)."
  type        = string
  default     = "arn:aws:iam::548801166108:role/LabRole"
}

variable "user_role_arn" {
  description = "ARN da role usada para login na AWS."
  type        = string
  default     = "arn:aws:iam::548801166108:role/voclabs"
}
