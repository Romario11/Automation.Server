terraform {

  backend "s3" {
    bucket = "my-automation-server-backend"
    key    = "automation_server/web_servers_infrastructure.tfstate"
    region = "eu-central-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
  state = "available"
}