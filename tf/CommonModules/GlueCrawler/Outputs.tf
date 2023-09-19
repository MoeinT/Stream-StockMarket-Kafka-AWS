output "crawlerName" {
  value = { for i, j in aws_glue_crawler.AllGlueCrawlers : j.id => j.id }
}

