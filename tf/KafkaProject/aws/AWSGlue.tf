# module "AWSGlueDatabase" {
#   source       = "../../CommonModules/GlueDatabase"
#   auth         = local.auth
#   allDatabases = ["de-youtube-raw-glue-db", "de-youtube-silver-glue-db"]
# }

# module "AWSGlueCrawler" {
#   source = "../../CommonModules/GlueCrawler"
#   auth   = local.auth
#   allCrawlers = {
#     "de-youtube-raw-json" = {
#       "glue_crawler_name" = "de-youtube-raw-json-crawler-${var.env}",
#       "role"              = module.Role.rolearn["de-youtube-glue-s3-role"],
#       "database_name"     = module.AWSGlueDatabase.DatabaseName["de-youtube-raw-glue-db"],
#       "s3_target" = {
#         "path" = "s3://${module.S3Buckets.BucketIds["de-youtube-raw-euw3"]}/youtube/raw_statistics_reference_data/"
#       }
#     },
#     "de-youtube-raw-csv" = {
#       "glue_crawler_name" = "de-youtube-raw-csv-crawler-${var.env}",
#       "role"              = module.Role.rolearn["de-youtube-glue-s3-role"],
#       "database_name"     = module.AWSGlueDatabase.DatabaseName["de-youtube-raw-glue-db"],
#       "s3_target" = {
#         "path" = "s3://${module.S3Buckets.BucketIds["de-youtube-raw-euw3"]}/youtube/raw_statistics/"
#       }
#     },
#     "de-youtube-silver-csv" = {
#       "glue_crawler_name" = "de-youtube-silver-glue-crawler-${var.env}",
#       "role"              = module.Role.rolearn["de-youtube-glue-s3-role"],
#       "database_name"     = module.AWSGlueDatabase.DatabaseName["de-youtube-silver-glue-db"]
#       "s3_target" = {
#         "path" = "s3://${module.S3Buckets.BucketIds["de-youtube-enriched-euw3"]}/youtube/"
#       }
#     },
#     "de-youtube-silver-parquet" = {
#       "glue_crawler_name" = "de-youtube-silver-glue-crawler-parquet-${var.env}",
#       "role"              = module.Role.rolearn["de-youtube-glue-s3-role"],
#       "database_name"     = module.AWSGlueDatabase.DatabaseName["de-youtube-silver-glue-db"]
#       "s3_target" = {
#         "path" = "s3://${module.S3Buckets.BucketIds["de-youtube-enriched-euw3"]}/youtube/raw_statistics/"
#       }
#     }
#   }
# }