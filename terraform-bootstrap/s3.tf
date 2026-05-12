resource "aws_s3_bucket" "tf_bucket" {
  bucket = "my-tf-bucket"

  tags = {
    Name    =   "my-tf-bucket"
    Environment =   "Test"
  }
}