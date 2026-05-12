resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "tf_bucket" {
  bucket = "tf-bucket-${random_id.bucket_id.hex}"

  tags = {
    Name    =   "my-tf-bucket"
    Environment =   "Test"
  }
}