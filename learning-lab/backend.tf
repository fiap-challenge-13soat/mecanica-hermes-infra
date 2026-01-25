terraform {
  backend "s3" {
    bucket  = "mechermes-tf-state"
    key     = "infra/learning-lab.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
