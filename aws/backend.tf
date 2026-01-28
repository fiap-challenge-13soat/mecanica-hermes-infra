terraform {
  backend "s3" {
    bucket         = "mechermes-tf-state"
    key            = "infra/aws.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "mechermes-tf-locks"
  }
}
