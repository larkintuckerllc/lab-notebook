def lambda_handler(event, context):
    greeting = event['greeting']
    phrase = '{} World!'.format(greeting)
    return { 'phrase': phrase }
