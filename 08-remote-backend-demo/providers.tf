terraform {
    backend "s3" {
        bucket         = "kode-catalyst-terraform-state"
        key            = "08-remote-backend-demo/terraform.tfstate"
        region         = "eu-north-1"
        use_lockfile = true
        encrypt        = true
    }
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