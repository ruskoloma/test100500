provider "aws" {
  region = var.aws_region

  default_tags {}
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-west-2"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
