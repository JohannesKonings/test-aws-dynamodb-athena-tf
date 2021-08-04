module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "persons-loader"
  description   = "load data of persons"
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  source_path = "./src/persons-loader"

}