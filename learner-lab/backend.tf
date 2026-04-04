terraform {
  backend "s3" {
    bucket         = "mechermes-tf-state-aws"
    key            = "infra/learner-lab.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "arn:aws:dynamodb:us-east-1:920117427782:table/mechermes-tf-locks"
  }
}
