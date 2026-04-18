output "dev_state_bucket" {
  value = aws_s3_bucket.dev_state.bucket
}

output "dev_lock_table" {
  value = aws_dynamodb_table.dev_lock.name
}

output "prod_state_bucket" {
  value = aws_s3_bucket.prod_state.bucket
}

output "prod_lock_table" {
  value = aws_dynamodb_table.prod_lock.name
}
