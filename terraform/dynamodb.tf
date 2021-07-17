resource "aws_dynamodb_table" "aws_dynamodb_table" {
  name         = "athena-test-data"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"
  range_key    = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }
}

resource "aws_kinesis_stream" "aws_kinesis_stream" {
  name        = "data_item_changes"
  shard_count = 1
}

resource "aws_dynamodb_kinesis_streaming_destination" "aws_dynamodb_kinesis_streaming_destination" {
  stream_arn = aws_kinesis_stream.aws_kinesis_stream.arn
  table_name = aws_dynamodb_table.aws_dynamodb_table.name
}
