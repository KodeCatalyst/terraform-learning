module "s3" {
  source       = "./modules/s3"
  environment  = var.environment
  bucket_name  = var.bucket_name
}