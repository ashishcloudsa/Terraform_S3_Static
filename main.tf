#Create S3 Bucket
resource "aws_s3_bucket" "mys3bucket" {
  bucket = var.bucketname
  }
resource "aws_s3_bucket_ownership_controls" "mys3bucket" {
  bucket = aws_s3_bucket.mys3bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_public_access_block" "mys3bucket" {
  bucket = aws_s3_bucket.mys3bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_acl" "mys3bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.mys3bucket,
    aws_s3_bucket_public_access_block.mys3bucket,
  ]

  bucket = aws_s3_bucket.mys3bucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mys3bucket.id
  key    = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
  
}
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mys3bucket.id
  key    = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
  
}
resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.mys3bucket.id
  key = "profile.png"
  source = "profile.png"

}
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mys3bucket.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
  depends_on = [ aws_s3_bucket_acl.mys3bucket ]
}