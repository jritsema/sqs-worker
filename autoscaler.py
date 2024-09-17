import boto3
import os

sqs = boto3.client("sqs")
ecs = boto3.client("ecs")


def handler(event, context):
    cluster = os.environ['CLUSTER']
    service = os.environ['SERVICE']
    sqs_url = os.environ['SQS']

    response = sqs.get_queue_attributes(
        QueueUrl=sqs_url,
        AttributeNames=[
            'ApproximateNumberOfMessages',
            'ApproximateNumberOfMessagesNotVisible'
        ])

    print(response['Attributes'])
    attributes = response['Attributes']
    available_messages = int(attributes['ApproximateNumberOfMessages'])
    in_process_messages = int(
        attributes['ApproximateNumberOfMessagesNotVisible'])

    # read service's current desiredCount
    serviceRes = ecs.describe_services(
        cluster=cluster,
        services=[service],
    )
    current = int(serviceRes['services'][0]['desiredCount'])
    print('current = ', current)
    desired = current

    # scale up only if there's more work than workers
    work = available_messages + in_process_messages
    if work > current:
        desired = work

    # note: don't scale down, even if there's more workers than work
    # since ECS will kill random tasks when scaling in,
    # tasks that could be still doing something

    # scale down when there's no work left
    if work == 0:
        desired = 0

    # cap max
    if desired > 100:
        desired = 100

    if desired != current:
        print(f'updating desired_count to {desired}')
        response = ecs.update_service(
            cluster=cluster,
            service=service,
            desiredCount=desired,
        )
        print(response)
