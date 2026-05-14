locals {
  # Shared Metadata from Module A
  project_name = "mechermes"
  environment  = "hml"

  # Manual "Bridge" for DocumentDB (Values from Module A)
  docdb_shared = {
    cluster_identifier = "mechermes-hml-docdb"
    endpoint           = "mechermes-hml-docdb.cluster-c0h2a0awilmg.us-east-1.docdb.amazonaws.com"
    reader_endpoint    = "mechermes-hml-docdb.cluster-ro-c0h2a0awilmg.us-east-1.docdb.amazonaws.com"
    secret_arn         = "arn:aws:secretsmanager:us-east-1:501883958463:secret:mechermes-hml-docdb-secret-POwoAL"
  }

  # Decoding the Secret (Parsed from data.tf)
  # This avoids hardcoding passwords in your files
  docdb_creds = jsondecode(
    data.aws_secretsmanager_secret_version.docdb_password.secret_string
  )
}