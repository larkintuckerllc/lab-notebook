provider "aws" {
  region = "us-east-1"
}

locals {
  identifier = "aws-step"

}

resource "aws_iam_role" "lambda" {
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
  name               = "${local.identifier}-lambda"
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda.id
}

resource "aws_lambda_function" "this" {
  filename         = "function.zip"
  function_name    = "StepLambda"
  handler          = "lambda_function.lambda_handler"
  role             = aws_iam_role.lambda.arn
  runtime          = "python3.8"
}

resource "aws_lambda_alias" "this" {
  function_name    = aws_lambda_function.this.arn
  function_version = "$LATEST"
  name             = "development"
}









































/*
resource "aws_sfn_state_machine" "this" {
  definition = <<EOF
{
  "Comment": "A Hello World example of the Amazon States Language using an AWS Lambda Function",
  "StartAt": "HelloWorld",
  "States": {
    "HelloWorld": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.lambda.arn}",
      "End": true
    }
  }
}
EOF
  name     = local.identifier
  role_arn = "${aws_iam_role.iam_for_sfn.arn}"
}
*/
