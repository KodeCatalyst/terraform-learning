terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = "http://localhost:4566"
    s3 = "http://localhost:4566"
    lambda = "http://localhost:4566"
    iam = "http://localhost:4566"
  }
}

// Creating VPC, Name, CIDR block, and Tags
resource "aws_vpc" "dev" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"

    tags  = {
        Name = "dev"
    }
}

// Creating Subnet in VPC
resource "aws_subnet" "public-subnet-1" {
    vpc_id = aws_vpc.dev.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"

    tags = {
        Name = "public_subnet"
    }
}

resource "aws_subnet" "public-subnet-2" {
    vpc_id = aws_vpc.dev.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1b"

    tags = {
        Name = "public_subnet"
    }
}

resource "aws_internet_gateway" "dev-gw" {
    vpc_id = aws_vpc.dev.id

    tags = {
        Name = "dev"
    }
}


resource "aws_route_table" "dev-public" {
    vpc_id = aws_vpc.dev.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dev-gw.id
    }
}

resource "aws_route_table_association" "dev-public-1"{
    subnet_id = aws_subnet.public-subnet-1.id
    route_table_id = aws_route_table.dev-public.id
}

resource "aws_route_table_association" "dev-public-2"{
    subnet_id = aws_subnet.public-subnet-2.id
    route_table_id = aws_route_table.dev-public.id
}

resource "aws_instance" "public-instance-1"{
    ami = "ami-5f2e2535"
    instance_type = "t2.micro"
    subnet_id  = "${aws_subnet.public-subnet-1.id}"
    key_name = "key11"

    tags = {
        Name = "public-instance-1"
    }
}

resource "aws_instance" "public-instance-2"{
    ami = "ami-5f2e2535"
    instance_type = "t2.micro"
    subnet_id  = "${aws_subnet.public-subnet-2.id}"
    key_name = "key11"

    tags = {
        Name = "public-instance-2"
    }
}