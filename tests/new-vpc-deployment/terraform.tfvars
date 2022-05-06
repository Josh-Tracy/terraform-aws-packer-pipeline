  
# --- Common ---#
  friendly_name_prefix = "joshtest"
  region = "us-east-1"

# --- VPC --- #
  create_vpc = true
  vpc_cidr_block        = "10.10.10.0/24"
  vpc_name              = "Packer CI CD Test"
  subnet_a_cidr         = "10.10.10.128/26"   
  subnet_a_az           = "us-east-1a"
  subnet_b_cidr         = "10.10.10.192/26"   
  subnet_b_az           = "us-east-1b"        
  subnet_c_cidr         = "10.10.10.0/25"     
  subnet_c_az           = "us-east-1c" 
  subnet_a_routetable_cidr       = "0.0.0.0/0"
  subnet_b_routetable_cidr       = "0.0.0.0/0"             
  subnet_c_routetable_cidr       = "0.0.0.0/0"

# --- Security Group Codebuild Permitted Ports --- #                
  ingress_ports = [22]
  ingress_allowed_cidr = ["0.0.0.0/0"]

# --- Code Commit --- #
  codecommit_repository_name        = "ansible-configs"
  codecommit_repository_description = "ansible configs for packer builds"

# --- Code Build --- #
  image                         = "aws/codebuild/ubuntu-base:14.04"
  type                          = "LINUX_CONTAINER"
  compute_type                  = "BUILD_GENERAL1_SMALL"
  buildspec_path                = "buildspec.yml"
  image_pull_credentials_type   = "CODEBUILD"
  codebuild_project_name        = "Packer-AMI-Creation"
  codebuild_project_description = "Creation of new AMI upon commit to dev branch"
  build_timeout                 = "15"

# --- Code Pipeline --- #
  branch                          = "dev" #check to see if this can be made and pulled in during codecommit
 # account_type                    = "390262997527"

# --- Alerts --- #
  sns_topic_name = "AMI-Build-Status"
  email_address  = "email@example.com" 