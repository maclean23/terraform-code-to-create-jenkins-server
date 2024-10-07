# provider.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.52.0"  # Use version 4.52.0 and above but below 5.0.0
    }
  }

  required_version = ">= 0.14"  # Ensure that Terraform version is at least 0.14
}

provider "aws" {
  region = "eu-west-2"  # Set your desired AWS region here
}
