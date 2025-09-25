resource "aws_s3_bucket" "sammy-new-bucket-example" {
  bucket = "my-tf-test-bucket-sammy"
  tags = {
    Name        = "sammy-new-bucket-sept-25"
    Environment = "Dev"
  }

}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.sammy-new-bucket-example.id
  versioning_configuration {
    status = "Enabled"
  }
}