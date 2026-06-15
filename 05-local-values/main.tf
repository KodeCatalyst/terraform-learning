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

locals {
  local_demo = "${var.project_name}_${var.environment}"
}

resource "aws_instance" "terraform_demo" {
  ami = "ami-05ec2ffaee0a0e6d4"
  instance_type = var.instance_type

  tags = {
    Name = "${local.local_demo}_instance"
  }
}

# resource "aws_vpc" "local_demo_vpc" {
#   cidr_block = var.cidr_block

#   tags = {
#     Name = local.local_setup
#   }
# }

# resource "aws_subnet" "local_demo_subnet" {
#   vpc_id            = aws_vpc.local_demo_vpc.id
#   cidr_block        = var.cidr_block
#   availability_zone = "eu-north-1a"

#   tags = {
#     Name = "${local.local_demo}_subnet"
#   }
# }

# resource "aws_instance" "local_demo_instance" {
#   ami           = "ami-05ec2ffaee0a0e6d4"
#   instance_type = var.instance_type
#   subnet_id     = aws_subnet.local_demo_subnet.id

#   tags = {
#     Name = "${local.local_demo}_instance"
#   }
# }