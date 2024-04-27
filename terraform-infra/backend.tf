terraform {
  backend "s3" {
    bucket = "codedevops-secops"
    key    = "ap-south-1"
    region = "us-east-1"
  }
}

