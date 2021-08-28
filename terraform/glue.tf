locals {
  glue-db-name             = "${var.TABLE_NAME}-db"
  glue-crawler-name        = "${var.TABLE_NAME}-crawler"
  glue-crawler-role-name   = "${var.TABLE_NAME}-crawler-role"
  glue-crawler-policy-name = "${var.TABLE_NAME}-crawler"
}

resource "aws_glue_catalog_database" "aws_glue_catalog_database" {
  name = local.glue-db-name
}

resource "aws_glue_crawler" "aws_glue_crawler" {
  database_name = aws_glue_catalog_database.aws_glue_catalog_database.name
  name          = local.glue-crawler-name
  role          = aws_iam_role.aws_iam_role_glue_crawler.arn

  configuration = jsonencode(
    {
      "Version" : 1.0
      CrawlerOutput = {
        Partitions = { AddOrUpdateBehavior = "InheritFromTable" }
      }
    }
  )

  s3_target {
    path = "s3://${aws_s3_bucket.aws_s3_bucket.bucket}"
  }
}

resource "aws_iam_role" "aws_iam_role_glue_crawler" {
  name = local.glue-crawler-role-name

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "glue.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "aws_iam_role_policy_glue_crawler" {
  name = local.glue-crawler-policy-name
  role = aws_iam_role.aws_iam_role_glue_crawler.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "*"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
    }
  )
}
