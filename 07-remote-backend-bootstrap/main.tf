resource "aws_s3_bucket" "terraform_state" {
    bucket = "kode-catalyst-terraform-state"

    lifecycle {
        prevent_destroy = true
    }
}

resource "aws_s3_bucket_versioning" "state_versioning"{
    bucket = aws_s3_bucket.terraform_state.id

    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
    bucket = aws_s3_bucket.terraform_state.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

//using dynamodb is depracated. aws now uses "use_lockfile = true" in the backend configuration to enable state locking. The following resource is commented out as it is no longer needed.
# resource "aws_dynamodb_table" "state_lock" {
#     name = "terraform-state-lock"
#     billing_mode = "PAY_PER_REQUEST"
#     hash_key = "LockID"

#     attribute {
#         name = "LockID"
#         type = "S"
#     }
# }