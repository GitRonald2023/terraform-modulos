#Salida del id de la BD
output "MySQL" {
    description = "ID de la base de datos"
    value = "ID de la BD MySQL ${aws_db_instance.myinstance.id}" 
}