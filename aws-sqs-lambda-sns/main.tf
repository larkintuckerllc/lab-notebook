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
