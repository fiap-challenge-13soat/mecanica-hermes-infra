variable "lab_role_arn" {
  description = "ARN da role permitida pelo AWS Learning Lab (usada pelo EKS)."
  type        = string
  default     = "arn:aws:iam::548801166108:role/LabRole"
}
