#Consulta de zonas de disponibiliad de la region
data "aws_availability_zones" "available" {}

#Creacion de private key para la ssh
resource "tls_private_key" "privatekey" {
  algorithm = "RSA"
  rsa_bits = 4096
}
#Creacion de la llave ssh (publica y privada) y descargar en linux
resource "aws_key_pair" "sshkey" {
  key_name = var.key_pair_name
  public_key = tls_private_key.privatekey.public_key_openssh
  provisioner "local-exec" {
    command = nonsensitive ("echo '${tls_private_key.privatekey.private_key_pem}' >> ./${var.key_pair_name}.pem")
  }
}

#Creacion de la instacia EC2 "bastion" en subred publica 1a para gestion de plataforma a traves de la misma desde internet con ssh 
resource "aws_instance" "bastion" {
  ami                         = "ami-069aabeee6f53e7bf"
  instance_type               = "t2.micro"
  key_name                    = var.key_pair_name
  associate_public_ip_address = true
  availability_zone           = data.aws_availability_zones.available.names[0]
  subnet_id                   = var.subnet-publics[0]
  tenancy                     = "default"
  security_groups             = [var.sec_group_public]
  tags = {
    "Name" = "Bastion"
    "Prod" = "Front"
  }
}

#Creacion de la instancia EC2 "back1-1a" en el back subred privada 1a para la APP
resource "aws_instance" "back1-1a" {
  count                       = 2 
  ami                         = "ami-069aabeee6f53e7bf"
  instance_type               = "t2.micro"
  key_name                    = var.key_pair_name
  associate_public_ip_address = false
  availability_zone           = data.aws_availability_zones.available.names[count.index]
  subnet_id                   = var.subnet-privates[count.index]
  tenancy                     = "default"
  security_groups             = [var.SGprivado]
  tags = {
    "Name" = "Back${data.aws_availability_zones.available.names[count.index]}"
    "Prod" = "Back"
  }
}
#Creacion de la EFS para almacenamiento persistente de las instancias back1-1a y back2-1b
resource "aws_efs_file_system" "efs-app" {
  creation_token   = var.efs-token-name
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  tags = {
    Name = "${var.efs-token-name}"
    Prod = "Back"
  }
}

#Asignacion de la subred privada y grupo de seguridad para el EFS creado anteriormente
resource "aws_efs_mount_target" "efs-mount" {
  file_system_id  = aws_efs_file_system.efs-app.id
  subnet_id       = var.subnet-privates[0]
  security_groups = [var.SGprivado]
}