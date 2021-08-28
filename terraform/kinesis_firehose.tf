locals {
  firehose-name            = "${var.TABLE_NAME}-firehose"
  fireshose-s3-bucket-name = "${var.TABLE_NAME}-firehose-s3-bucket"
  fireshose-log-group-name = "/aws/kinesisfirehose/${local.firehose-name}"
}

resource "aws_kinesis_firehose_delivery_stream" "aws_kinesis_firehose_delivery_stream" {
  name        = local.firehose-name
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.aws_kinesis_stream.arn
    role_arn           = aws_iam_role.aws_iam_role.arn
  }

  extended_s3_configuration {
    role_arn   = aws_iam_role.aws_iam_role.arn
    bucket_arn = aws_s3_bucket.aws_s3_bucket.arn

    processing_configuration {
      enabled = "true"

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${module.lambda_function_persons_firehose_converter.lambda_function_arn}:$LATEST"
        }
      }
    }


    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.aws_cloudwatch_log_group_firehose.name
      log_stream_name = aws_cloudwatch_log_stream.aws_cloudwatch_log_stream_firehose.name
    }
  }
}

resource "aws_cloudwatch_log_group" "aws_cloudwatch_log_group_firehose" {
  name              = local.fireshose-log-group-name
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "aws_cloudwatch_log_stream_firehose" {
  name           = "S3Delivery"
  log_group_name = aws_cloudwatch_log_group.aws_cloudwatch_log_group_firehose.name
}


resource "aws_s3_bucket" "aws_s3_bucket" {
  bucket = local.fireshose-s3-bucket-name
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.aws_kms_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_iam_role" "aws_iam_role" {
  name = "${var.TABLE_NAME}-analysis-role"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "firehose.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
  })
  inline_policy {
    name = "${var.TABLE_NAME}-analysis-policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "logs:PutLogEvents"
          ]
          Effect   = "Allow"
          Resource = aws_cloudwatch_log_stream.aws_cloudwatch_log_stream_firehose.arn
        },
        {
          Action = [
            "kinesis:*",
          ]
          Effect   = "Allow"
          Resource = aws_kinesis_stream.aws_kinesis_stream.arn
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:AbortMultipartUpload",
            "s3:GetBucketLocation",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:ListBucketMultipartUploads",
            "s3:PutObject"
          ],
          "Resource" : [
            aws_s3_bucket.aws_s3_bucket.arn,
            "${aws_s3_bucket.aws_s3_bucket.arn}/*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "kms:*",
          ],
          "Resource" : [
            aws_kms_key.aws_kms_key.arn
          ],
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "lambda:InvokeFunction",
            "lambda:GetFunctionConfiguration"
          ],
          "Resource" : [
            "${module.lambda_function_persons_firehose_converter.lambda_function_arn}:$LATEST"
          ]
        }
      ]
    })
  }

}
