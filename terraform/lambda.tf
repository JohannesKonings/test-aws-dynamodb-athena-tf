module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "persons-loader"
  description   = "load data of persons"
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  environment_variables = {
    TABLE_NAME = var.TABLE_NAME
  }

  attach_policy_json = true

  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["dynamodb:PutItem"]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.aws_dynamodb_table.arn
      },
    ]
  })

  source_path = "./src/persons-loader"

}

module "lambda_function_persons_firehose_converter" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "persons-firehose-converter"
  description   = "add missing linefeed"
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  source_path = "./src/firehose-converter"

}
