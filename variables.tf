#Variable para networking VPC 'cidr'
variable "cidr-vpc" {
  description = "Bloque CIDR para la VPC"
  default = "193.168.0.0/16"
}

#Variable para le region de despliegue de networking
variable "region" {
  description = "Region para el despliegue del networking"
  default = "us-east-1"
}



