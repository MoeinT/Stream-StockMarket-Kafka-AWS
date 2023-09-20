output "BucketIds" {
  value = { for i, j in aws_s3_bucket.AllBuckets : j.tags.Name => j.id }
}

output "BucketArns" {
  value = { for i, j in aws_s3_bucket.AllBuckets : j.tags.Name => j.arn }
}