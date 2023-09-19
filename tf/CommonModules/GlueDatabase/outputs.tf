output "DatabaseName" {
  value = { for i, j in aws_glue_catalog_database.AllDatabases : j.name => j.name }
}