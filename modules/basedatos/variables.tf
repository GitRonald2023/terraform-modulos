#Variable para el nombre de la base de datos
variable "nombre-bd-mysql" {
  description = "nombre de la base de datos para la app"
  type        = string
  default = "mysqldbapp"
}
#Variable para el usuario de la base de datos
variable "username-bd" {
  description = "Usuario para la BD MySQL"
  type        = string
  default = "adminapp"
}
#Variable para el parrword de la base de datos
variable "password-bd" {
  description = "password del usuario de la BD"
  type        = string
  default = "adminapp"
}
#variable para SG de modulo networking
variable "SGprivado" {
  description = "SG privado para la BD"
  type = string
}
variable "subnet-privates" {
  description = "Subnet privadas para la BD"
  type = list(string)
}