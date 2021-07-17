resource "aws_kinesis_firehose_delivery_stream" "aws_kinesis_firehose_delivery_stream" {
  name        = "athena-test-data-stream"
  destination = "s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.aws_kinesis_stream.arn
    role_arn           = aws_iam_role.aws_iam_role.arn
  }

  s3_configuration {
    role_arn   = aws_iam_role.aws_iam_role.arn
    bucket_arn = aws_s3_bucket.aws_s3_bucket.arn

    output_format_configuration {
      serializer {
        parquet_ser_de {}
      }
    }

  }
}


resource "aws_s3_bucket" "aws_s3_bucket" {
  bucket = "athena-test-data-bucket"
  acl    = "private"
}

resource "aws_iam_role" "aws_iam_role" {
  name = "athena-test-data-iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "aws_iam_role_policy" {
  name   = "athena-test-data-iam_role_policy"
  role   = aws_iam_role.aws_iam_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "*"
      ],
      "Resource": [
        "*"
      ]
        }
  ]
}
EOF
}
