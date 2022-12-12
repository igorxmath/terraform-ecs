# output "db_endpoint" {
#     value = aws_db_instance.db-server-instance.address
# }

output "lb_endpoint" {
  value = aws_lb.lb-app.dns_name
}