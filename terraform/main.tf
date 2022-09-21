terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = "~> 3.27"
      version = "~> 4.24"
    }
  }

  required_version = ">= 0.14.9"
}


## For several things, we need the AWS Account ID. Lets define that here
# https://stackoverflow.com/questions/68397972/how-to-use-aws-account-id-variable-in-terraform
data "aws_caller_identity" "account_id" {
  provider = aws
}

locals {
  account_id               = data.aws_caller_identity.account_id.account_id
}
