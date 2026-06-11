terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
  region                      = "eu-north-1"
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
    availability_zone = "eu-north-1a"

    tags = {
        Name = "public_subnet"
    }
}

resource "aws_subnet" "public-subnet-2" {
    vpc_id = aws_vpc.dev.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-north-1b"

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
    ami = "ami-05ec2ffaee0a0e6d4"
    instance_type = "t3.micro"
    subnet_id  = "${aws_subnet.public-subnet-1.id}"

    tags = {
        Name = "public-instance-1"
    }
}

resource "aws_instance" "public-instance-2"{
    ami = "ami-05ec2ffaee0a0e6d4"
    instance_type = "t3.micro"
    subnet_id  = "${aws_subnet.public-subnet-2.id}"

    tags = {
        Name = "public-instance-2"
    }
}