locals {
  base_tags = {
    Terraform   = true
    Environment = "dev"
    Author      = "tsukpa"
  }
}

################################################################################
# S3 static website bucket
################################################################################
resource "aws_s3_bucket" "s3-static-website" {
  bucket = var.bucket_name
  force_destroy = true # This will be force delete all objects, no need to empty when run terraform destroy command
  tags = merge(local.base_tags, {
    Name = var.bucket_name
  })
}

################################################################################
# S3 public access settings
################################################################################
resource "aws_s3_bucket_public_access_block" "static_site_bucket_public_access" {
  bucket = aws_s3_bucket.s3-static-website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

################################################################################
# S3 bucket static website configuration
################################################################################
resource "aws_s3_bucket_website_configuration" "static_site_bucket_website_config" {
  bucket = aws_s3_bucket.s3-static-website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
