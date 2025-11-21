terraform {
  required_version = "~> 1.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" 
    }
  }

  backend "s3" {
    bucket       = "tfstate-obelion"
    key          = "env/{terraform.workspace}/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}


provider "aws" {
  region = var.region
}