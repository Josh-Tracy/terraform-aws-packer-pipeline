terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = "Test"
      Owner       = "JT"
      Project     = "Packer CI/CD Pipeline"
      Terraform   = "True"
      Terraform_Method = "CLI"
    }
  }
}

module "packer-pipeline" {
  source                = "../../"     # relative path to the module

# --- Common ---#
  friendly_name_prefix = var.friendly_name_prefix

# --- VPC --- #
  create_vpc = var.create_vpc
  vpc_cidr_block        = var.vpc_cidr_block
  vpc_name              = var.vpc_name
  subnet_a_cidr         = var.subnet_a_cidr
  subnet_a_az           = var.subnet_a_az
  subnet_b_cidr         = var.subnet_b_cidr
  subnet_b_az           = var.subnet_b_az
  subnet_c_cidr         = var.subnet_c_cidr
  subnet_c_az           = var.subnet_c_az
  subnet_a_routetable_cidr       = var.subnet_a_routetable_cidr                 
  subnet_b_routetable_cidr       = var.subnet_b_routetable_cidr                
  subnet_c_routetable_cidr       = var.subnet_c_routetable_cidr

# --- Security Group Codebuild Permitted Ports --- #                
  ingress_ports = var.ingress_ports
  ingress_allowed_cidr = var.ingress_allowed_cidr

# --- Code Commit --- #
  codecommit_repository_name        = var.codecommit_repository_name
  codecommit_repository_description = var.codecommit_repository_description

# --- Code Build --- #
  image                         = var.image
  type                          = var.type
  compute_type                  = var.compute_type
  buildspec_path                = var.buildspec_path
  image_pull_credentials_type   = var.image_pull_credentials_type
  codebuild_project_name        = var.codebuild_project_name
  codebuild_project_description = var.codebuild_project_description
  build_timeout                 = var.build_timeout

# --- Code Pipeline --- #
  branch                          = var.branch #check to see if this can be made and pulled in during codecommit
 # account_type                    = "390262997527"

# --- Alerts --- #
  sns_topic_name = var.sns_topic_name
  email_address  = var.email_address
}