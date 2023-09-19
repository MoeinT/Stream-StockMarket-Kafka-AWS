output "BucketIds" {
  value = { for i, j in aws_s3_bucket.AllBuckets : j.tags.Name => j.id }
}

# output "test" {
#   value = {
#     for key, bucket in aws_s3_bucket.AllBuckets : key => bucket if bucket.apply_server_side_encryption == true
#   }
# }

output "BucketArns" {
  value = { for i, j in aws_s3_bucket.AllBuckets : j.tags.Name => j.arn }
}