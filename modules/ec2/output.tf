#Salida del ID del Bastion 
output "EC2Bastion" {
    description = "ID del Bastion en EC2"
    value = "${aws_instance.bastion.id}"
}
#Salida ID de las instancias en el back
output "EC2Backs" {
    description = "Id's de las instancias EC2 en el Back"
    value = ["${element(aws_instance.back1-1a.*.id,0)}","${element(aws_instance.back1-1a.*.id,1)}"]
}
#Salida del nombre de la llave SSH
output "llaveSSH" {
    description = "Nombre de la llave SSH"
    value = "Nombre de la llave SSH es: ${var.key_pair_name}"
}