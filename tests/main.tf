provider "aws" {
  region = "us-east-1"
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
  source                = "../"     # relative path to the module

# --- Common ---#
  friendly_name_prefix = var.friendly_name_prefix

# --- VPC --- #
  vpc_cidr_block        = "10.10.10.0/24"     # CIDR Block for the VPC
  vpc_name              = "Packer CI CD Test" # Name of the VPC
  subnet_a_cidr         = "10.10.10.128/26"   # Subnet A CIDR
  subnet_a_az           = "us-east-1a"        # Subnet A AZ
  public_subnet_a_name  = "Public subnet A"   # Subnet A Name
  subnet_b_cidr         = "10.10.10.192/26"   # Subnet B CIDR
  subnet_b_az           = "us-east-1b"        # Subnet B AZ
  public_subnet_b_name  = "Public subnet B"   # Subnet B Name
  subnet_c_cidr         = "10.10.10.0/25"     #Subnet C CIDR
  subnet_c_az           = "us-east-1c"        #Subnet C AZ
  private_subnet_c_name = "Private subnet C"  # Subnet C Name
# Internet Gateway settings
  igw_tag_name = "Packer CI CD Test Internet Gateway" # Tag name to be applied to the Internet GW
# NAT Gateway settings
  natgw_tag_name = "Packer CI CD Test NAT Gateway" # Tag name to be applied to the NAT GW
# Routing Settings
  subnet_a_routetable_tag_name   = "Public subnet A routes"    # Route Table for subnet A Name
  subnet_b_routetable_tag_name   = "Public subnet B routes"    # Route Table for subnet B Name
  subnet_c_routetable_tag_name   = "Private subnet C routes"   # Route Table for subnet C Name
  subnet_a_routetable_cidr       = "0.0.0.0/0"                 # Route Table for subnet A CIDR
  subnet_b_routetable_cidr       = "0.0.0.0/0"                 # Route Table for subnet B CIDR
  subnet_c_routetable_cidr       = "0.0.0.0/0"                 # Route Table for subnet C CIDR
  sg_name_https                  = "allow http https and ssh"  # Name of this security group
  ssh_ingress_rule_description   = "Allow SSH from anywhere"   # SSH ingress rule description
  ssh_from_port                  = 22                          # SSH port
  ssh_to_port                    = 22                          # SSh port
  ingress_ssh_cidr               = ["0.0.0.0/0"]               # ssh ingress CIDR
  https_ingress_rule_description = "Allow https from anywhere" # HTTPS ingress rule description
  https_from_port                = 443                         # HTTPS port
  https_to_port                  = 443                         # HTTPs port
  ingress_https_cidr             = ["0.0.0.0/0"]               # HTTPS ingress CIDR
  http_ingress_rule_description  = "Allow http from anywhere"  # HTTP ingress rule description
  http_from_port                 = 80                          # HTTP port
  http_to_port                   = 80                          # HTTP port
  ingress_http_cidr              = ["0.0.0.0/0"]               # HTTP ingress CIDR
}
module "codecommit" {
  source                            = "./modules/codecommit" # relative path to the code commit module
  codecommit_repository_name        = "Packer-Pipeline-Demo"
  codecommit_repository_description = "Configuration for a VM that triggers a Packer build on commit"
}

module "codebuild" {
  source                        = "./modules/codebuild"
  image                         = "aws/codebuild/ubuntu-base:14.04"
  type                          = "LINUX_CONTAINER"
  compute_type                  = "BUILD_GENERAL1_SMALL"
  buildspec_path                = "buildspec.yml"
  image_pull_credentials_type   = "CODEBUILD"
  codebuild_project_name        = "Packer-AMI-Creation"
  codebuild_project_description = "Creation of new AMI upon commit to dev branch"
  build_timeout                 = "15"
  vpc_id                        = module.vpc.vpc_id
  subnet_c_arn                  = module.vpc.subnet_c_arn
  subnet_a_id                   = module.vpc.subnet_a_id
  subnet_c_id                   = module.vpc.subnet_c_id
  security_group_id             = module.vpc.security_group_id
  git_repository_name           = module.codecommit.repository_name
}