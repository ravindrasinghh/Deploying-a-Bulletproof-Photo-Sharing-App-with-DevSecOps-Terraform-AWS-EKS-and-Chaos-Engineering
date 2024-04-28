resource "aws_dynamodb_table" "photos_metadata" {
  name           = "PhotosMetadata"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "photo_id"

  attribute {
    name = "photo_id"
    type = "S" # S denotes String
  }
  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.kms.arn
  }
  tags = {
    Name = "${local.project}-PhotosMetadata"
  }
}

resource "aws_kms_key" "kms" {
  description = "KMS key for DynamoDB table encryption"
}