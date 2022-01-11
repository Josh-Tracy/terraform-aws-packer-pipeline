provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "Dev"
      Owner       = "Josh Tracy"
      Project     = "Packer CI/CD Pipeline"
      Terraform   = "True"
    }
  }
}