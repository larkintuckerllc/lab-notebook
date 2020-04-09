provider "aws" {
  region = "us-east-1"
}

locals {
  identifier = "aws-sqs-lambda-sns"
}

resource "aws_sqs_queue" "this" {
  name                        = "${local.identifier}.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}

resource "aws_iam_role" "this" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  name               = local.identifier
}

resource "aws_lambda_function" "this" {
  filename         = "function.zip"
  function_name    = "SQSLambdaSNS"
  handler          = "lambda_function.lambda_handler"
  role             = aws_iam_role.this.arn
  runtime          = "python3.8"
}

resource "aws_lambda_alias" "this" {
  function_name    = aws_lambda_function.this.arn
  function_version = "$LATEST"
  lifecycle {
    ignore_changes = [function_version]
  }
  name             = "development"
}

