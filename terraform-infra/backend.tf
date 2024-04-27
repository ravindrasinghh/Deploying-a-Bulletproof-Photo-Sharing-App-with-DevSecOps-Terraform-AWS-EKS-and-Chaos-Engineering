terraform {
  backend "s3" {
    bucket = "codedevops-secops"
    key    = "secops-dev.tfstae"
    region = "ap-south-1"
  }
}

