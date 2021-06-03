terraform {
  backend "s3" {
    encrypt = true
    region  = "us-east-1"
  }
}

resource "aws_s3_bucket" "terraform-state-storage-s3" {
  bucket        = var.BACKEND_CONFIG_BUCKET
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

variable "BACKEND_CONFIG_BUCKET" {}
