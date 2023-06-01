output "vpc-id" {
    value = module.networking.vpc_id 
}
output "subnet-publics" {
    value = module.networking.subnet-publics
}
output "subnet-privates" {
    value = module.networking.subnet-privates  
}
output "SGpublico" {
    value = module.networking.SGpublico 
}
output "SGprivado" {
    value = module.networking.SGprivado  
}
output "bastion" {
    value = module.ec2.EC2Bastion
  
}
output "EC2Backs" {
    value = module.ec2.EC2Backs
  
}
output "DNSalb" {
    value = module.alb.DNSalb 
}
output "MySQL" {
    value = module.BDMySQL.MySQL
}