terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.56.0"
    }
  }
}
#uso el perfil "default" de aws credentials
provider "aws" {
  region = "us-east-1"
  #  profile = "default"
}


