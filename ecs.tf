locals {
  container_name = "app"
  image          = "public.ecr.aws/jritsema/defaultbackend"
}

module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "~> 5.6"

  cluster_name = var.name

  fargate_capacity_providers = {
    FARGATE      = {}
    FARGATE_SPOT = {}
  }

  tags = var.tags
}

module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "~> 5.6"

  name        = var.name
  cluster_arn = module.ecs_cluster.arn

  # supports external task def deployments
  # by ignoring changes to task definition and desired count
  ignore_task_definition_changes = true
  desired_count                  = 1

  # Task Definition
  enable_execute_command = false

  container_definitions = {
    (local.container_name) = {

      image = local.image

      environment = [
        {
          "name" : "SQS_QUEUE_URL",
          "value" : aws_sqs_queue.main.url
        },
      ]

      readonly_root_filesystem = false
    }
  }

  subnet_ids = data.aws_subnets.main.ids

  security_group_rules = {
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tasks_iam_role_name        = "${var.name}-tasks"
  tasks_iam_role_description = "role for ${var.name}"

  tasks_iam_role_statements = [
    {
      actions = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:ChangeMessageVisibility"
      ]
      resources = [aws_sqs_queue.main.arn]
    },
    {
      actions = [
        "s3:ListObjects",
        "s3:GetObject",
        "s3:DeleteObject",
      ]
      resources = [
        "${data.aws_s3_bucket.main.arn}/*",
      ]
    },
  ]

  tags = var.tags
}
