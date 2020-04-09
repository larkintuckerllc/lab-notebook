# TODO

> TODO

[TODO](TODO)

## Network Diagram

![Network Diagram](aws-ec2.png)

## Variables

## Resources

## Commands

```
aws sqs send-message \
  --queue-url https://sqs.us-east-1.amazonaws.com/143287522423/aws-sqs-lambda-sns.fifo \
  --message-body "{ \"id\": \"a\", \"subject\": \"Hello Subject\", \"body\": \"Hello Body\" }" \
  --message-group-id 0
```

CREATE SUBS MANUALLY