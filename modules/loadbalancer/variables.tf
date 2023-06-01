#variables para el nombre del bucket S3 de logs del balanceador de aplicaciones
variable "bucket-logs-alb" {
  description = "bucket para los logs del balanceador de carga de aplicaciones"
  type        = string
  default = "bucket-lba-logs-app"
}
#Variable para el nombre del balanceador de aplicaciones
variable "lba-app-bootcamp" {
  description = "nombre del balanceador de carga para la app"
  type        = string
  default = "alb-app-bootcamp"
}
#variable desde modulo netwotking
variable "sec_group_public" {
  description = "GP publico para el load balancer"
  type = string
}
#variable con subnets del modulo networking
variable "subnet-publics" {
  description = "Subnet para load balancer"
  type = list(string)
}