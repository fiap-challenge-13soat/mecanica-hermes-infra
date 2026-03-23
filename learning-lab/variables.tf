variable "project_name" {
  description = "Nome do projeto."
  type        = string
  default     = "mechermes"
}

variable "aws_account_id" {
  description = "ID da conta AWS (usado para construir ARNs de roles)."
  type        = string
  default     = "211125510254"
}

locals {
  lab_role_arn  = "arn:aws:iam::${var.aws_account_id}:role/LabRole"
  user_role_arn = "arn:aws:iam::${var.aws_account_id}:role/voclabs"
}
