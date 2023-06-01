# Creacion de VPC
resource "aws_vpc" "VPCBootCamp" {
  cidr_block           = var.cidr-vpc
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "VPCBootCamp"
  }
}

#Creacion Gateway de internet para subredes publicas
resource "aws_internet_gateway" "internet-gateway-vpcbootcamp" {
  vpc_id = aws_vpc.VPCBootCamp.id
  tags = {
    "Name" = "${var.nombre-igw}"
  }
}

#consulta de zonas de disponibilidad de la region
data "aws_availability_zones" "available" {}

#Creacion Subred publica en AZ 1a
resource "aws_subnet" "public_1a_bootcamp" {
  count                   = 2
  vpc_id                  = aws_vpc.VPCBootCamp.id
  cidr_block              = cidrsubnet(var.cidr-vpc, 8, count.index) #funcion cidrsubnet para calcular las subnets publicas desde la cidr de la vpc
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "SubnetPublic${data.aws_availability_zones.available.names[count.index]}"
  }
}

#Creacion ruta para internet en subredes publicas
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.VPCBootCamp.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway-vpcbootcamp.id
  }
  tags = {
    Name = "rt-public-vpcBootCamp"
  }
}

# Asociación de subredes publicas
resource "aws_route_table_association" "asociacion_rt_publics-1a" {
  count = 2
  route_table_id = aws_route_table.public_route.id
  subnet_id      = "${element(aws_subnet.public_1a_bootcamp.*.id, count.index)}"
}

#Creacion de grupo de seguridad publico
resource "aws_security_group" "sec_group_public" {
  name        = var.nombre-sg-public
  vpc_id      = aws_vpc.VPCBootCamp.id
  description = "grupo de seguridad sunredes publicas"
  tags = {
    "Name" = "${var.nombre-sg-public}"
  }
}

#Asignación de reglas para salida a internet
resource "aws_security_group_rule" "salida-internet" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sec_group_public.id
}

#Asignación de regla para ssh desde internet
resource "aws_security_group_rule" "entrada-internet-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sec_group_public.id
}

#Asignacion de regla para http desde internet
resource "aws_security_group_rule" "entrada-internet-http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sec_group_public.id
}

#Asignacion de regla para ssm 
resource "aws_security_group_rule" "entrada-internet-ssm" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sec_group_public.id
}

#Creacion de subred privadas
resource "aws_subnet" "private_1a_bootcamp" {
  count                   = 2
  vpc_id                  = aws_vpc.VPCBootCamp.id
  cidr_block              = cidrsubnet(var.cidr-private, 7, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "SubnetPrivate${data.aws_availability_zones.available.names[count.index]}"
  }
}

#Asociacion de VPC a nat-gateway
resource "aws_eip" "nat_gateway_eip" {
  vpc = true
}

#Creacion de nat-gateway para subredes privadas
resource "aws_nat_gateway" "nat-gw-bootcamp" {
  allocation_id     = aws_eip.nat_gateway_eip.id
  connectivity_type = "public"
  subnet_id         = element(aws_subnet.public_1a_bootcamp.*.id, 0)
  tags = {
    Name = "nat-gw-subnet-public en ${element(aws_subnet.public_1a_bootcamp.*.id, 0)}"
  }
}

#Creacion tabla de rutas para alcanzar internet desde subred privadas a traves de nat-gateway
resource "aws_route_table" "rt-private" {
  vpc_id = aws_vpc.VPCBootCamp.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw-bootcamp.id
  }
  tags = {
    "Name" = "rt-private"
  }
}

#Asociacion en la tabla de ruta ptrivada a internet de la subnet privada 1a 
resource "aws_route_table_association" "asociacion-rt-privada-1a" {
  count = 2
  route_table_id = aws_route_table.rt-private.id
  subnet_id      = element(aws_subnet.private_1a_bootcamp.*.id, count.index)
}

#Asociacion en la tabla de ruta privada a internet de la subnet privada 1b
#resource "aws_route_table_association" "asociacion-rt-privada-1b" {
#  route_table_id = aws_route_table.rt-private.id
#  subnet_id      = element(aws_subnet.private_1a_bootcamp.*.id, 1)
#}

#Creacion del grupo de seguridad privado con reglas de ingreso y salida 
resource "aws_security_group" "sg-private" {
  name        = var.nombre-sg-private
  vpc_id      = aws_vpc.VPCBootCamp.id
  description = "sg para base de datos y aplicacion web"
  ingress {
    description = "ingreso de conexiones ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "${var.nombre-sg-private}"
  }
}
#Creacion de reglas para el grupo de seguridad privado para la APP en puerto 5000
resource "aws_security_group_rule" "sg-private-aplicacion" {
  type              = "ingress"
  from_port         = 5000
  to_port           = 5000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg-private.id
}
#Creacion de regla para el grupo de seguridad privado para la BD MySql en puerto 3306
resource "aws_security_group_rule" "sg-private-base-datos" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg-private.id
}

#Creacion de regla para el grupo de seguridad para uso de conexiones SSM
resource "aws_security_group_rule" "sg-private-ssm" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg-private.id
}