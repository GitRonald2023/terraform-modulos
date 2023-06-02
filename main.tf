#llama el module networking
module "networking" {
  source = "./modules/networking"
}
#llama el module ec2
module "ec2" {
  source           = "./modules/ec2"
  subnet-publics   = module.networking.subnet-publics
  sec_group_public = module.networking.SGpublico
  subnet-privates  = module.networking.subnet-privates
  SGprivado        = module.networking.SGprivado
}
#llama al modulo del load balancer
module "alb" {
  source           = "./modules/loadbalancer"
  sec_group_public = module.networking.SGpublico
  subnet-publics   = module.networking.subnet-publics
}
#llama al modulo de la BD
module "BDMySQL" {
  source          = "./modules/basedatos"
  SGprivado       = module.networking.SGprivado
  subnet-privates = module.networking.subnet-privates
}