output "s3_bucket" {
  value = aws_s3_bucket.tfstate.bucket
}

output "dynamodb_table" {
  value = {
    table = aws_dynamodb_table.tfstate.name
    hash_key = aws_dynamodb_table.tfstate.hash_key
  }
}
