terraform {
  backend "s3" {
    bucket = "devsecops-backend-codedevops"
    key    = "secops-dev.tfstae"
    region = "ap-south-1"
  }
}

