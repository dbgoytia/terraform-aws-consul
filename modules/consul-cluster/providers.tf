terraform {
  required_version = ">= 0.12.26"
}

provider "aws" {
  region = var.region
}