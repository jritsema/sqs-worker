# sqs-worker

Boilerplate for a Fargate container that processes an SQS queue.

Includes Terraform and Python code.

This repo uses [asdf](https://asdf-vm.com/) to manage the `terraform` CLI and the various other tools it depends upon. Completely optional.

```
 Choose a make command to run

  init    project initialization - install tools and register git hook
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_cluster"></a> [ecs\_cluster](#module\_ecs\_cluster) | terraform-aws-modules/ecs/aws//modules/cluster | ~> 5.6 |
| <a name="module_ecs_service"></a> [ecs\_service](#module\_ecs\_service) | terraform-aws-modules/ecs/aws//modules/service | ~> 5.6 |

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_sqs_queue.dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
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
