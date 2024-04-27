resource "aws_dynamodb_table" "photos_metadata" {
  name           = "PhotosMetadata"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "photo_id"

  attribute {
    name = "photo_id"
    type = "S"  # S denotes String
  }

  tags = {
    Name = "PhotosMetadata"
  }
}
