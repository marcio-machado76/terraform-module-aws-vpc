//Exemplo para remote state

# terraform {
#   backend "s3" {
#     bucket         = "example-remote-backend"
#     key            = "vpc/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "example-tfstate-locking"
#     encrypt        = true
#   }
# }