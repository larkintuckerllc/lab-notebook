provider "aws" {
  region = "us-east-1"
}

locals {
  identifier = "aws-sqs-lambda-sns"
}

resource "aws_sns_topic" "this" {
  name = local.identifier 
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

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.this.id
}

resource "aws_iam_role_policy" "this_sqs_write_queue" {
    name   = "SQSWriteQueue"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "sqs:DeleteMessage",
                "sqs:ReceiveMessage",
                "sqs:GetQueueAttributes"
            ],
            "Resource": "${aws_sqs_queue.this.arn}"
        }
    ]
}
EOF
    role   = aws_iam_role.this.id
}


resource "aws_iam_role_policy" "this_sns_publish_topic" {
    name   = "SNSPublishTopic"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "sns:Publish",
            "Resource": "${aws_sns_topic.this.arn}"
        }
    ]
}
EOF
    role   = aws_iam_role.this.id
}

resource "aws_lambda_function" "this" {
  environment {
    variables = {
      APP_TOPIC_ARN = aws_sns_topic.this.arn
    }
  }
  filename         = "function.zip"
  function_name    = "SQSLambdaSNS"
  handler          = "lambda_function.lambda_handler"
  role             = aws_iam_role.this.arn
  runtime          = "python3.8"
}

resource "aws_lambda_alias" "this" {
  function_name    = aws_lambda_function.this.arn
  function_version = "$LATEST"
  name             = "development"
}

resource "aws_lambda_event_source_mapping" "this" {
  event_source_arn = aws_sqs_queue.this.arn
  function_name    = aws_lambda_alias.this.arn
}
