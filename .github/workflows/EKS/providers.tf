terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.12.0"
    }
  }
}



data "aws_caller_identity" "current" {
}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
