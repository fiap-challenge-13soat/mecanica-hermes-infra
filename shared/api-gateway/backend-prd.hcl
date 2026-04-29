bucket         = "mechermes-tf-state-aws"
key            = "api-gateway/prd/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "arn:aws:dynamodb:us-east-1:920117427782:table/mechermes-tf-locks"
encrypt        = true
