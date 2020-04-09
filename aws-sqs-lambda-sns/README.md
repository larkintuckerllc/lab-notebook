# SQS, Lambda, and SNS

## Resources

**SNS Topic**

**SQS Queue**

**Lambda Function**

## Commands

Requires setting up SNS Topic subscription manually, e.g., email yourself.

```
aws sqs send-message \
  --queue-url XXX \
  --message-body "{ \"id\": \"a\", \"subject\": \"Hello Subject\", \"body\": \"Hello Body\" }" \
  --message-group-id 0
```