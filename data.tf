# data "aws_caller_identity" "main" {}

data "aws_subnets" "main" {
  filter {
    name   = "tag:Name"
    values = [var.subnet_tag_name]
  }
}

data "aws_s3_bucket" "main" {
  bucket = var.s3_bucket
}
