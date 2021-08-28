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

resource "aws_kms_key" "aws_kms_key" {
  description             = "KMS key for whole project"
  deletion_window_in_days = 10
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
