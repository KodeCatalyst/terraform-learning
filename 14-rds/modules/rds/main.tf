//Security group for the RDS instance
resource "aws_security_group" "rds_sg" {
  name       = "${var.environment}-rds-sg"
  description = "Allow PostgreSQL traffic from the app layer"
  vpc_id     = var.vpc_id

  ingress {
    description = "PostgreSQL from allowed CIDR"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    //only allow private subnet of application to connect
    //in production
    cidr_blocks = [var.allowed_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}

  tags = {
    Name        = "${var.environment}-rds-sg"
    Environment = var.environment
  }
}

//Subnet group
resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

//Db parameter group
resource "aws_db_parameter_group" "main" {
  name        = "${var.environment}-postgres-params"
  family      = "postgres15"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  tags = {
    Name        = "${var.environment}-postgres-params"
    Environment = var.environment
  }
}

//RDS instance
resource "aws_db_instance" "main" {
  identifier = "${var.environment}-postgres"
  engine = "postgres"
  engine_version = "15"
  instance_class = var.instance_class
  allocated_storage = 20
  storage_type = "gp2"

  db_name = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  parameter_group_name = aws_db_parameter_group.main.name

  multi_az = false
  publicly_accessible = false
  //skipping final snapshot for learning purpose. 
  skip_final_snapshot = true

  tags = {
    Name        = "${var.environment}-postgres"
    Environment = var.environment
  }

}