terraform {
  
  backend "s3" {
    bucket = "tf-bucket-8375f78d"
    key = "practice_cluster/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
  }
}