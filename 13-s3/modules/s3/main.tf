// The Bucket
resource "aws_s3_bucket" "main" {
    bucket = var.bucket_name
    //I'm adding force destroy so terraform can delete 
    //the bucket even with versioned object.. 
    //This should not be the case for production where important stuff like logs are stored.
    force_destroy = true

    tags = {
        Name        = var.bucket_name
        Environment = var.environment
    }
}

resource "aws_s3_bucket_public_access_block" "main" {
    bucket = aws_s3_bucket.main.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

//Versioning
resource "aws_s3_bucket_versioning" "main" {
    bucket = aws_s3_bucket.main.id

    versioning_configuration {
        status = "Enabled"
    }
}

//Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
    bucket = aws_s3_bucket.main.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

//Lifecycle rule
resource "aws_s3_bucket_lifecycle_configuration" "main" {
    bucket = aws_s3_bucket.main.id

    rule {
        id = "transition-to-ia"
        status = "Enabled"

        filter {}
        
        transition {
            days = 30
            storage_class = "STANDARD_IA"
        }

        transition {
            days = 90
            storage_class = "GLACIER"
        }

        expiration {
            days = 365
        }
    }
}

