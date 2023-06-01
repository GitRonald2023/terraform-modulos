#Salida de ID VPC creada
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.VPCBootCamp.id
}
#Salida de ID subnets publicas creadas
output "subnet-publics" {
    description = "ID's de subnets publicas"
    value = ["${element(aws_subnet.public_1a_bootcamp.*.id,0)}","${element(aws_subnet.public_1a_bootcamp.*.id,1)}"]
}
#Salida de ID subnets privadas creadas
output "subnet-privates" {
    description = "ID's de subnets publicas"
    value = ["${element(aws_subnet.private_1a_bootcamp.*.id,0)}","${element(aws_subnet.private_1a_bootcamp.*.id,1)}"]
}
#Salida de ID de internet gateway
output "igw" {
    description = "ID del IGW"
    value = "ID de IGW: ${aws_internet_gateway.internet-gateway-vpcbootcamp.id}"
}
#Salida de ID de NAT Gateway
output "NATgw" {
    description = "ID del IGW"
    value = "ID de IGW: ${aws_nat_gateway.nat-gw-bootcamp.id}"
}
#Salida de ID del grupo de seguridad publico
output "SGpublico" {
    description = "ID del SGpublico"
    value = aws_security_group.sec_group_public.id
}
#Salida de ID del grupo de seguridad privado
output "SGprivado" {
    description = "ID del SGprivado"
    value = aws_security_group.sg-private.id
}

