locals {
  athena-query-results-s3-name = "${var.TABLE_NAME}-query-results"
  athena-workgroup-name        = "${var.TABLE_NAME}-workgroup"
}
resource "aws_s3_bucket" "aws_s3_bucket_bookings_query_results" {
  bucket = local.athena-query-results-s3-name
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.aws_kms_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_athena_workgroup" "aws_athena_workgroup" {
  name = local.athena-workgroup-name

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.aws_s3_bucket_bookings_query_results.bucket}/output/"

      encryption_configuration {
        encryption_option = "SSE_KMS"
        kms_key_arn       = aws_kms_key.aws_kms_key.arn
      }
    }
  }
}
