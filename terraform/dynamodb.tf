resource "aws_dynamodb_table" "aws_dynamodb_table" {
  name         = var.TABLE_NAME
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"

  attribute {
    name = "pk"
    type = "S"
  }

}

resource "aws_kinesis_stream" "aws_kinesis_stream" {
  name        = "${var.TABLE_NAME}-data-stream"
  shard_count = 1
}

resource "aws_dynamodb_kinesis_streaming_destination" "aws_dynamodb_kinesis_streaming_destination" {
  stream_arn = aws_kinesis_stream.aws_kinesis_stream.arn
  table_name = aws_dynamodb_table.aws_dynamodb_table.name
}
