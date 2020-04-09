import boto3
import json
from os import getenv

sns = boto3.resource('sns')
topic = sns.Topic(getenv('APP_TOPIC_ARN'))

def lambda_handler(event, context):
    records = event['Records']
    for record in records:
        payload = json.loads(record['body'])
        subject = payload['subject']
        body = payload['body']
        topic.publish(
            Message=body,
            Subject=subject
        )