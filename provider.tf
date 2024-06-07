provider "aws" {
  region = local.region
  default_tags {
    tags = {
      Terraform = "true"
      Owner     = "sre/devops"
      Project   = "lab-aws-IaC"
    }
  }
}