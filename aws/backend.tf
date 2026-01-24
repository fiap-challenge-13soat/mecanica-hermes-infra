terraform {
  backend "s3" {
    bucket = "mechermes-tf-state"
    key    = "infra/aws.tfstate"
    region = "us-east-1"
  }
}
