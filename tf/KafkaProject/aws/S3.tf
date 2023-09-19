# module "S3Buckets" {
#   source = "../../CommonModules/S3"
#   auth   = local.auth
#   env    = var.env
#   allBuckets = {
#     "de-youtube-raw-euw3" = {
#       "bucket"        = "de-youtube-raw-euw3-${var.env}",
#       "force_destroy" = false
#     },
#     "de-youtube-raw-euw3-athena" = {
#       "bucket" = "de-youtube-raw-euw3-athena-job-${var.env}",
#     },
#     "de-youtube-enriched-euw3" = {
#       "bucket" = "de-youtube-enriched-euw3-${var.env}",
#     }
#   }
# }