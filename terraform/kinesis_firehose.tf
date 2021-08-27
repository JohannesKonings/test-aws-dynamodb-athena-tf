locals {
  firehose-name = "${var.TABLE_NAME}-firehose-stream"
}

resource "aws_kinesis_firehose_delivery_stream" "aws_kinesis_firehose_delivery_stream" {
  name        = local.firehose-name
  destination = "s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.aws_kinesis_stream.arn
    role_arn           = aws_iam_role.aws_iam_role.arn
  }

  s3_configuration {
    role_arn   = aws_iam_role.aws_iam_role.arn
    bucket_arn = aws_s3_bucket.aws_s3_bucket.arn

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.aws_cloudwatch_log_group_firehose.name
      log_stream_name = aws_cloudwatch_log_group.aws_cloudwatch_log_group_firehose.name
    }
  }
}

resource "aws_cloudwatch_log_group" "aws_cloudwatch_log_group_firehose" {
  name              = "/aws/firehose/dummy"
  retention_in_days = 7
}


resource "aws_s3_bucket" "aws_s3_bucket" {
  bucket = var.S3_BUCKET_NAME
  acl    = "private"
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
            "firehose:*",
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Effect   = "Allow"
          Resource = "arn:aws:firehose:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:deliverystream/${local.firehose-name}"
        }
      ]
    })
  }

}


