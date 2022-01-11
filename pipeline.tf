module "codecommit" {
  source                = "./modules/codecommit"                    # relative path to the code commit module
  codecommit_repository_name = "Packer Pipeline Demo"
  codecommit_repository_description = "Configuration for a VM that triggers a Packer build on commit"
}

module "codebuild" {
  source = "./modules/codebuild"
  codebuild_source_repository = module.codecommit.codecommit_url
  vpc_id = module.vpc.vpc_id
  subnet_a_arn = module.vpc.subnet_a_arn
  subnet_a_id = module.vpc.subnet_a_id
  subnet_b_arn = module.vpc.subnet_b_arn
  subnet_b_id = module.vpc.subnet_b_id

}