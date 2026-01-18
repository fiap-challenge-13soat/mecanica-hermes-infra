# terraform {
#   cloud {
#     organization = "gelonezi"
#     workspaces {
#       name = "mechanica-hermes-devops"
#     }
#   }
# }

terraform {
  backend "local" {
    path = "tfstate/terraform.tfstate"
  }
}
