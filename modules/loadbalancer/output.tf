#Salida del bucket para el balanceador
output "BucketALB" {
    description = "ID del bucket para el balanceador"
    value = "ID del bucket para el balanceador: ${aws_s3_bucket.alb-logs.id}"
}
#Salida para el ALB
output "ALB" {
    description = "ID del ALB"
    value = "ID del ALB: ${aws_lb.alb-app-bootcamp.id}"
}
#DNS del ALB
output "DNSalb" {
    description = "DNS del ALB"
    value = aws_lb.alb-app-bootcamp.dns_name
}
