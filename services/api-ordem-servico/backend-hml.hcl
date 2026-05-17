bucket         = "mechermes-tf-state-aws-microsservices"
key            = "infra/api-ordem-servico/db-hml.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "arn:aws:dynamodb:us-east-1:501883958463:table/mechermes-tf-locks"
