#Creacion del bucket para los logs
resource "aws_s3_bucket" "alb-logs" {
  bucket = var.bucket-logs-alb
}

#Creacion de la politca para el bucket de logs del balanceador
resource "aws_s3_bucket_policy" "permitir-alb-logs" {
  bucket = aws_s3_bucket.alb-logs.id
  policy = data.aws_iam_policy_document.permitir-alb-logs.json
}

#Text de la Politica definida para el bucket
data "aws_iam_policy_document" "permitir-alb-logs" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::127311923021:root"]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.alb-logs.arn}/s3-alb-app/AWSLogs/077418163678/*"
    ]
  }
}

#Creación del balanceador de carga de aplicaciones en la red publica 1b con el grupo de seguridad publico
resource "aws_lb" "alb-app-bootcamp" {
  name                       = var.lba-app-bootcamp
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.sec_group_public]
  subnets                    = ["${element(var.subnet-publics,0)}","${element(var.subnet-publics,1)}"]
  enable_deletion_protection = false
  access_logs {
    bucket  = aws_s3_bucket.alb-logs.id
    prefix  = "s3-alb-app"
    enabled = true
  }
  tags = {
    Name = "${var.lba-app-bootcamp}"
    Prod = "Front"
  }
}