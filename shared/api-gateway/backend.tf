terraform {
  backend "s3" {
    encrypt        = true
    dynamodb_table = "arn:aws:dynamodb:us-east-1:920117427782:table/mechermes-tf-locks"
  }
}
