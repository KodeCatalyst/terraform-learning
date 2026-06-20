resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name        = "${var.environment}-vpc"
        Environment = var.environment
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name        = "${var.environment}-igw"
        Environment = var.environment
    }
}

resource "aws_subnet" "public" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = cidrsubnet(var.vpc_cidr, 8, 1)
    availability_zone = "${var.region}a"
    map_public_ip_on_launch = true

    tags = {
        Name        = "${var.environment}-public-subnet"
        Environment = var.environment
    }
}

resource "aws_subnet" "private" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = cidrsubnet(var.vpc_cidr, 8, 2)
    availability_zone = "${var.region}b"

    tags = {
        Name        = "${var.environment}-private-subnet"
        Environment = var.environment
    }
}

resource "aws_subnet" "database" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = cidrsubnet(var.vpc_cidr, 8, 3)
    availability_zone = "${var.region}c"

    tags = {
        Name        = "${var.environment}-database-subnet"
        Environment = var.environment
    }
}

resource "aws_eip" "nat" {
    domain = "vpc"

    tags = {
        Name        = "${var.environment}-nat-eip"
        Environment = var.environment
    }
}

resource "aws_nat_gateway" "main" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public.id

    tags = {
        Name        = "${var.environment}-nat-gateway"
        Environment = var.environment
    }

    depends_on = [aws_internet_gateway.main]
}

// Creating route tables
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name        = "${var.environment}-public-rt"
        Environment = var.environment
    }
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.main.id
    }    

    tags = {
        Name        = "${var.environment}-private-rt"
        Environment = var.environment
    } 
}

resource "aws_route_table" "database_rt" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name        = "${var.environment}-database-rt"
        Environment = var.environment
    }
}

// Associating route tables with subnets
resource "aws_route_table_association" "public_assoc" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_assoc" {
    subnet_id      = aws_subnet.private.id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "database_assoc" {
    subnet_id      = aws_subnet.database.id
    route_table_id = aws_route_table.database_rt.id
}