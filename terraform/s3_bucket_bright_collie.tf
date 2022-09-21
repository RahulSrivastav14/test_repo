resource "aws_s3_bucket" "s3_bucket_bright_collie" {
  bucket = "${local.account_id}-bright-collie"
}

output "s3_bucket_bright_collie" {
  value = aws_s3_bucket.s3_bucket_bright_collie.arn
}