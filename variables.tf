variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "name" {
  description = "The name of the app"
  type        = string
}

variable "tags" {
  description = "tags"
  type        = map(string)
}

variable "subnet_tag_name" {
  description = "The subnet tag name to use to deploy the ECS service"
  type        = string
}

variable "s3_bucket" {
  description = "The name of the S3 bucket to use"
  type        = string
}
