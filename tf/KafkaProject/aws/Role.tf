# # Creating a role for the AWS Glue
# module "Role" {
#   source = "../../CommonModules/Role"
#   auth   = local.auth
#   roles = {
#     aws-glue-role = {
#       "name"               = "de-youtube-glue-s3-role",
#       "assume_role_policy" = local.assume_aws_glue_role_policy
#     },
#     aws-lambda-role = {
#       "name"               = "de-youtube-lambda-s3-role",
#       "assume_role_policy" = local.assume_aws_lambda_role_policy
#     }
#   }
# }

# Adding the S3 full access to the above aws glue role
# module "RolePolicy" {
#   source = "../../CommonModules/RolePolicy"
#   auth   = local.auth
#   policies = {
#     "s3FullAccessAWSGlue" = {
#       "role"       = module.Role.rolename["de-youtube-glue-s3-role"],
#       "policy_arn" = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
#     },
#     "ServiceRoleAWSGlue" = {
#       "role"       = module.Role.rolename["de-youtube-glue-s3-role"],
#       "policy_arn" = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
#     },
#     "s3FullAccessAWSLambda" = {
#       "role"       = module.Role.rolename["de-youtube-lambda-s3-role"],
#       "policy_arn" = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
#     },
#     "ServiceRoleAWSLambda" = {
#       "role"       = module.Role.rolename["de-youtube-lambda-s3-role"],
#       "policy_arn" = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
#     }
#   }
# }

