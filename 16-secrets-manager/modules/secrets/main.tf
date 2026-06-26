//Database credentials secret
resource "aws_secretsmanager_secret" "db_credentials" {
    name = "${var.environment}/db/credentials"
    description = "Database credentials for ${var.environment} environment"

    //I set it to 0 for learning purposes, it should be higher eg 7-30 days in production
    recovery_window_in_days = 0

    tags = {
        Name        = "${var.environment}-db-credentials"
        Environment = var.environment
    }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
    secret_id     = aws_secretsmanager_secret.db_credentials.id
    
    secret_string = jsonencode({
        username = var.db_username
        password = var.db_password
        host     = var.db_host
        port = 5432
        dbname = "appdb"
    })
}

//API key secret
resource "aws_secretsmanager_secret" "api_key" {
    name = "${var.environment}/api/key"
    description = "Third party API key for ${var.environment} environment"

    //I set it to 0 for learning purposes, it should be higher eg 7-30 days in production
    recovery_window_in_days = 0

    tags = {
        Name        = "${var.environment}-api-key"
        Environment = var.environment
    }
}

resource "aws_secretsmanager_secret_version" "api_key" {
    secret_id     = aws_secretsmanager_secret.api_key.id
    
    secret_string = jsonencode({
        api_key = var.api_key
    })
}

//Fetching the secret back using data source
data "aws_secretsmanager_secret_version" "db_credentials" {
    secret_id = aws_secretsmanager_secret.db_credentials.id

    depends_on = [aws_secretsmanager_secret_version.db_credentials]
}