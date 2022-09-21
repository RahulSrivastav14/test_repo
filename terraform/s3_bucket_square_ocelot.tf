resource "aws_s3_bucket" "s3_bucket_square_ocelot" {
  bucket = "${local.account_id}-square-ocelot"
}

resource "aws_s3_bucket_policy" "s3_bucket_policy_square_ocelot" {
  bucket = aws_s3_bucket.s3_bucket_square_ocelot.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Deny",
      "Principal":"*",
      "Action":"s3:GetObject",
      "Resource":"${aws_s3_bucket.s3_bucket_square_ocelot.arn}/*",
      "Condition":{
        "Bool":{
          "aws:SecureTransport":"false"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_server_side_encryption_configuration_square_ocelot" {
  bucket = aws_s3_bucket.s3_bucket_square_ocelot.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_blocksquare_ocelot" {
  bucket                  = aws_s3_bucket.s3_bucket_square_ocelot.bucket
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

output "s3_bucket_square_ocelot" {
  value = aws_s3_bucket.s3_bucket_square_ocelot.arn
}