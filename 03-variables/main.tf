terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "main_server" {
  ami           = "ami-05ec2ffaee0a0e6d4"
  instance_type = var.instance_type
  count         = var.instance_count

  tags = {
    Name = "main_server"
  }
}

resource "aws_iam_user" "dev_users" {
  //count is not suitable for this case where the resource has a unique identity. count is suitable when the resources are distinquished mainly by number.
  //count = length(var.user_names)
  //name = var.user_names[count.index]

  for_each = toset(var.user_names)
  name     = each.value
}