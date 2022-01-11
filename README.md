### Work In Progress
## Instructions 

# Scenario 1: Creating a new VPC with this code
Running `terraform apply` from the root directory, as is, will build a new VPC with 2 public subnets that auto assign public IPs, 1 private subnet, an IGW and a NATGW. If you choose to use an existing VPC, continue to scenario 2.

1.) terraform plan, apply, and stuff
2.) Clone the CodeCommit repo you created from the HTTPS URL
3.) Create a dev branch, fill it with this ___ code
4.) Commit
5.) Build will start
4.)?

# Scenario 2: Using with an existing VPC

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.6 |
| aws | >= 3.71.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.71.0 |

## Inputs - vpc.tf

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_cidr_block | CIDR Block for the VPC | `string` | `null` | yes |
| vpc_name | Name of the VPC | `string` | `null` | yes |
| subnet_a_cidr | CIDR for public subnet A | `string` | `null` | yes |
| subnet_a_az  | Availability Zone for public subnet A | `string` | `null` | yes |
| public_subnet_a_name| Sets the name of public subnet A | `string` | `null` | yes |
| subnet_b_cidr| CIDR for public subnet B | `string` | `null` | yes |
| subnet_b_az | Availability Zone for public subnet B | `string` | `null` | yes |
| public_subnet_b_name | Sets the name of public subnet B | `string` | `null` | yes |
| subnet_c_cidr | CIDR for PRIVATE subnet C | `string` | `null` | yes |
| subnet_c_az | Availability Zone for PRIVATE subnet C | `string` | `null` | yes |
| private_subnet_c_name | Sets the name of PRIVATE subnet C | `string` | `null` | yes |
| igw_tag_name | Internet Gateway Name tag | `string` | `null` | yes |
| natgw_tag_name | NAT Gateway Name tag | `string` | `null` | yes |
| subnet_a_routetable_tag_name | Sets the name of subnet A routetable | `string` | `null` | yes |
| subnet_b_routetable_tag_name | Sets the name of subnet B routetabley | `string` | `null` | yes |
| subnet_c_routetable_tag_name | Sets the name of subnet C routetable | `string` | `null` | yes |
| subnet_a_routetable_cidr | Subnet A CIDR for traffic flow | `string` | `null` | yes |
| subnet_b_routetable_cidr | Subnet B CIDR for traffic flow | `string` | `null` | yes |
| subnet_c_routetable_cidr | Subnet C CIDR for traffic flow | `string` | `null` | yes |
| sg_name_https | Sets the name of the security group | `string` | `null` | yes |
| ssh_ingress_rule_description | Description for this security group rule | `string` | `null` | yes |
| ssh_from_port | Port for SSH | `number` | `null` | yes |
| ssh_to_port | Port for SSH | `number` | `null` | yes |
| ingress_ssh_cidr | CIDR to allow traffic from on this rule | `string` | `null` | yes |
| https_ingress_rule_description | Description for this security group rule | `string` | `null` | yes |
| https_from_port  | HTTPS Port | `number` | `null` | yes |
| https_to_port | HTTPS Port | `number` | `null` | yes |
| ingress_https_cidr | CIDR to allow traffic from on this rule | `string` | `null` | yes |
| http_ingress_rule_description | Description for this security group rule | `string` | `null` | yes |
| http_from_port   | HTTP port | `number` | `null` | yes |
| http_to_port | HTTP port | `number` | `null` | yes |
| ingress_http_cidr | CIDR to allow traffic from on this rule | `string` | `null` | yes |


## Inputs - pipeline.tf

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| codecommit_repository_name | Sets the name of the CodeCommit Repository | `string` | `null` | yes |
| codecommit_repository_description | Sets the description for the CodeCommit repository | `string` | `null` | yes |
| branch | The branch for CodePipeline to begin building when a commit is detected. | `string` | `null` | yes |
| pipeline_deployment_bucket_name | Name of the S3 bucket that will store CodePipeline artifacts | `string` | `null` | yes |
| codepipeline_role_name | The role name for CodePipeline IAM role | `string` | `null` | yes |
| codepipeline_policy_name | The policy for the CodePipeline IAM policiy | `string` | `null` | no |
| account_type | Human readable name of the targets accounts | `string` | `null` | yes |

## Outputs

| Name | Description |
|------|-------------|
