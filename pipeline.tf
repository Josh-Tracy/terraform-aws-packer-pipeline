module "codecommit" {
  source                            = "./modules/codecommit" # relative path to the code commit module
  codecommit_repository_name        = "Packer-Pipeline-Demo"
  codecommit_repository_description = "Configuration for a VM that triggers a Packer build on commit"
}

module "codebuild" {
  source                        = "./modules/codebuild"
  image                         = "aws/codebuild/ubuntu-base:14.04"
  type                          = "LINUX_CONTAINER"
  compute_type                  = "BUILD_GENERAL_1_SMALL"
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

module "codepipeline" {
  source                          = "./modules/codepipeline"
  branch                          = "dev"
  git_repository_name             = module.codecommit.repository_name
  pipeline_deployment_bucket_name = "packer-ami-build"
  codepipeline_role_name          = "codepipeline-packer-ami-build"
  codepipeline_policy_name        = "codepipeline-packer-ami-build"
  codebuild_project_name          = module.codebuild.codebuild_project_name
  account_type                    = "390262997527"
}

module "alerts" {
  source         = "./modules/alerts"
  sns_topic_name = "AMI-Build-Status"
  email_address  = "email.example.com"
}