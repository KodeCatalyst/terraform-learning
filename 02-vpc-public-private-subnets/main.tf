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


resource "aws_vpc" "devopshint-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "devopshint-vpc VPC"
  }
}

// Public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.devopshint-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-north-1a"

  tags = {
    Name = "Public Subnet"
  }
}
resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.devopshint-vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-north-1a"

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_internet_gateway" "devopshint-igw" {
  vpc_id = aws_vpc.devopshint-vpc.id

  tags = {
    Name = "devopshint igw"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.devopshint-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devopshint-igw.id
  }
}

resource "aws_route_table_association" "public-route-table-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_eip" "devopshint-eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.devopshint-igw]
}

resource "aws_nat_gateway" "devopshint-nat-gateway" {
  allocation_id = aws_eip.devopshint-eip.id
  subnet_id     = aws_subnet.public-subnet.id

  tags = {
    Name = "devopshint nat gateway"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.devopshint-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.devopshint-nat-gateway.id
  }

}

resource "aws_route_table_association" "private-route-table-association" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_security_group" "security_group" {
  description = "Allow limited inbound external traffic"
  vpc_id      = aws_vpc.devopshint-vpc.id
  name        = "terraform_ec2_private_sg"

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
  }

  egress {
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

  tags = {
    Name = "terraform-ec2-private-sg"
  }
}

resource "aws_instance" "public-ec2-instance" {
  ami                         = "ami-05ec2ffaee0a0e6d4"
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.security_group.id]
  subnet_id                   = aws_subnet.public-subnet.id
  key_name                    = "devopshint-key"
  associate_public_ip_address = true

  tags = {
    Name = "public EC2 instance"
  }
}

resource "aws_instance" "private-ec2-instance" {
  ami                         = "ami-05ec2ffaee0a0e6d4"
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.security_group.id]
  subnet_id                   = aws_subnet.private-subnet.id
  key_name                    = "devopshint-key"
  associate_public_ip_address = false

  tags = {
    Name = "private EC2 instance"
  }
}