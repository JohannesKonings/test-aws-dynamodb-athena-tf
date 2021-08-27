terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.43.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project = "test-aws-dynamodb-athena-tf"
    }
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
