terraform {
  backend "s3" {
    encrypt        = true
    dynamodb_table = "mechermes-tf-locks"
  }
}
