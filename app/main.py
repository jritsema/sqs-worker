import os
import logging
from log import debug, info, warn, error
import boto3
import time

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
)

# Create an SQS client
sqs = boto3.client('sqs')

# Get the URL of the SQS queue
queue_url = os.environ.get('SQS_QUEUE_URL')
info(f"SQS Queue URL = {queue_url}")


def process_message(message):

    # Process the message body
    info(message)
    logging.info(f"Processing message: {message['Body']}")

    # Add your custom message processing logic here
    # ...

    time.sleep(5)

    # Delete the processed message from the queue
    logging.info(f"Deleting message: {message['ReceiptHandle']}")
    sqs.delete_message(
        QueueUrl=queue_url,
        ReceiptHandle=message['ReceiptHandle']
    )


def poll_queue():

    # Receive messages from the queue
    logging.info(f"Polling queue: {queue_url}")
    response = sqs.receive_message(
        QueueUrl=queue_url,
        MaxNumberOfMessages=1,  # Maximum number of messages to retrieve
        WaitTimeSeconds=20  # Wait time for long polling (reduces API calls)
    )

    # Process received messages
    for message in response.get('Messages', []):
        process_message(message)


if __name__ == '__main__':

    # Poll the queue indefinitely
    while True:
        poll_queue()
