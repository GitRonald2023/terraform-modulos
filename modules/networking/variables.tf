#variable 'CIDR'para VPC 
variable "cidr-vpc" {
    description = "Bloque CIDR para VPC"
    type = string
    default = "193.168.0.0/16"
}

#Variables para el internet gateway
variable "nombre-igw" {
  description = "Tag Name para el internet gateway"
  type        = string
  default = "igw-vpcbootcamp"
}

#Variable para el nombre del el grupo de seguridad publico
variable "nombre-sg-public" {
  description = "nombre grupo de seguridad publico"
  type        = string
  default = "sgpublic"
}

#Bloque inicial de CIDR para las subnets privadas
variable "cidr-private" {
  description = "Bloque CIDR privado inicial"
  type = string
  default = "193.168.128.0/17"
}

#Variable para el grupo de seguridad privado
variable "nombre-sg-private" {
  description = "nombre grupo seguridad privada"
  type        = string
  default = "sgprivate"
}