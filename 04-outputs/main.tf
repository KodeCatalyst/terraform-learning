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

resource "aws_instance" "web" {
  ami           = "ami-05ec2ffaee0a0e6d4"
  instance_type = "t3.micro"
  key_name      = "devopshint-key"

  tags = {
    Name = "web"
  }
}
