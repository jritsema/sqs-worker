# sqs-worker

Boilerplate for a Fargate container that processes an SQS queue.

Includes Terraform and Python code.

This repo uses [asdf](https://asdf-vm.com/) to manage the `terraform` CLI and the various other tools it depends upon. Completely optional.

## Usage

To initialize the project:

```
make init
```

This will install the required tools and register a pre-commit hook.

To run the pre-commit checks:

```
make checks
```

To see a summary of the Terraform resource changes:

```
make summary
```

## Autoscaling

This project includes a Lambda-based autoscaler that scales the ECS service based on the number of messages in the SQS queue. It runs on a 1-minute schedule and checks the queue attributes to determine if the service needs to be scaled up or down.

## Monitoring

The project also includes a CloudWatch dashboard that provides visibility into the following metrics:

- Messages Queued
- Messages Processing
- Workers Desired
- Workers Running
- CPU Utilization
- Memory Utilization

## Python App

The Python app that runs in the Fargate container is located in the `app/` directory. It uses the `boto3` library to receive messages from the SQS queue, process them, and delete them from the queue.

## Deployment

The Python app can be built and deployed using the `deploy.sh` script in the `app/` directory. This script logs in to the ECR registry, builds and pushes the Docker image, and then updates the ECS service to use the new image.


# Terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | ~> 2.2 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_cluster"></a> [ecs\_cluster](#module\_ecs\_cluster) | terraform-aws-modules/ecs/aws//modules/cluster | ~> 5.6 |
| <a name="module_ecs_service"></a> [ecs\_service](#module\_ecs\_service) | terraform-aws-modules/ecs/aws//modules/service | ~> 5.6 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_dashboard.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_dashboard) | resource |
| [aws_cloudwatch_event_rule.queue_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.queue_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_ecr_repository.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_iam_role.queue_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.queue_autoscaler_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_alias.queue_autoscaler_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_alias) | resource |
| [aws_lambda_function.queue_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_cloudwatch_to_call_queue_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_sqs_queue.dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [archive_file.queue_autoscaler](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_s3_bucket.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_subnets.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the app | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | The name of the S3 bucket to use | `string` | n/a | yes |
| <a name="input_subnet_tag_name"></a> [subnet\_tag\_name](#input\_subnet\_tag\_name) | The subnet tag name to use to deploy the ECS service | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | tags | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dead_letter_queue_arn"></a> [dead\_letter\_queue\_arn](#output\_dead\_letter\_queue\_arn) | dead letter sqs queue arn |
| <a name="output_dead_letter_queue_url"></a> [dead\_letter\_queue\_url](#output\_dead\_letter\_queue\_url) | dead letter sqs queue url |
| <a name="output_main_queue_arn"></a> [main\_queue\_arn](#output\_main\_queue\_arn) | main sqs queue arn |
| <a name="output_main_queue_url"></a> [main\_queue\_url](#output\_main\_queue\_url) | main sqs queue url |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
