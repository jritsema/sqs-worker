locals {
  queue_autoscaler_namespace   = "${var.name}-queue-autoscaler"
  queue_autoscaler_description = "Autoscales ${module.ecs_service.name} based on ${aws_sqs_queue.main.name}'s queue length"
}

resource "aws_iam_role" "queue_autoscaler" {
  name = "${local.queue_autoscaler_namespace}-lambdarole"

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
}

resource "aws_iam_role_policy" "queue_autoscaler_logs" {
  name = "${local.queue_autoscaler_namespace}-lambdapolicy"
  role = aws_iam_role.queue_autoscaler.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecs:UpdateService",
        "ecs:DescribeServices"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "sqs:GetQueueAttributes"
      ],
      "Resource": [
        "${aws_sqs_queue.main.arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_lambda_function" "queue_autoscaler" {
  function_name    = local.queue_autoscaler_namespace
  description      = local.queue_autoscaler_description
  filename         = data.archive_file.queue_autoscaler.output_path
  source_code_hash = data.archive_file.queue_autoscaler.output_base64sha256
  role             = aws_iam_role.queue_autoscaler.arn
  handler          = "autoscaler.handler"
  runtime          = "python3.12"
  timeout          = "100"
  tags             = var.tags

  environment {
    variables = {
      SQS     = aws_sqs_queue.main.id
      CLUSTER = module.ecs_cluster.name
      SERVICE = module.ecs_service.name
    }
  }
}

data "archive_file" "queue_autoscaler" {
  type        = "zip"
  source_file = "${path.module}/autoscaler.py"
  output_path = "lambda-${local.queue_autoscaler_namespace}.zip"
}

resource "aws_lambda_alias" "queue_autoscaler_alias" {
  name             = local.queue_autoscaler_namespace
  description      = local.queue_autoscaler_description
  function_name    = aws_lambda_function.queue_autoscaler.function_name
  function_version = "$LATEST"
}

resource "aws_cloudwatch_event_rule" "queue_autoscaler" {
  name                = local.queue_autoscaler_namespace
  description         = local.queue_autoscaler_description
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "queue_autoscaler" {
  rule = aws_cloudwatch_event_rule.queue_autoscaler.name
  arn  = aws_lambda_function.queue_autoscaler.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_queue_autoscaler" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.queue_autoscaler.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.queue_autoscaler.arn
}
