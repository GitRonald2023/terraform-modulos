#bucket para guardar el estado de terraform MUY IMPORTANTE 
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "cloudcamp-terraform-state-proy-final"
}
#Activacion de la opcion de versioning en el bucket
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
#creacion de una bd dynamo para bloquear el estado desde terraform
resource "aws_dynamodb_table" "terraform_locks" {
  name           = "cloudcamp-ddb-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  depends_on = [
        aws_s3_bucket_versioning.terraform_state_versioning
    ]
}
#Asignacion del archivo .tfstate de terraform al bucket
#terraform {
#  depends_on = [aws_s3_bucket.terraform_state_bucket]
#  backend "s3" {
#    bucket         = "cloudcamp-terraform-state-proy-final"
#    key            = "stage-cloudcamp/terraform.tfstate"
#    region         = "us-east-1"
#    encrypt        = true
#    dynamodb_table = "cloudcamp-ddb-lock"
#  }
#}
