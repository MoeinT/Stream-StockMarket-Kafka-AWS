module "AWSGlueDatabase" {
  source       = "../../CommonModules/GlueDatabase"
  auth         = local.auth
  allDatabases = ["stockmarket-raw-kafka"]
}

module "AWSGlueCrawler" {
  source = "../../CommonModules/GlueCrawler"
  auth   = local.auth
  allCrawlers = {
    "stockmarket-raw-json" = {
      "glue_crawler_name" = "stockmarket-raw-json-${var.env}",
      "role"              = module.Role.rolearn["stockmarket-glue-s3-role"],
      "database_name"     = module.AWSGlueDatabase.DatabaseName["stockmarket-raw-kafka"],
      "s3_target" = {
        "path" = "s3://${module.S3Buckets.BucketIds["stock-market"]}/Raw"
      }
    }
  }
}