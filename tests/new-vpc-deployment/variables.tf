#----------------------------------------------------#
# Common Vars
#----------------------------------------------------#
variable "friendly_name_prefix" {
  type        = string
  description = "Friendly name prefix for unique resource naming across deployments."

  validation {
    condition     = can(regex("^[[:alnum:]]+$", var.friendly_name_prefix)) && length(var.friendly_name_prefix) < 13
    error_message = "Must only contain alphanumeric characters and be less than 13 characters."
  }
}

variable "region" {
  type        = string
  description = "Region to deploy resources into"
  default     = "us-east-1"
}
#----------------------------------------------------#
# VPC vars
#----------------------------------------------------#

variable "create_vpc" {
  description = "Option to create and deploy pipeline into new VPC and subnets, or use existing one"
  type        = bool
  default     = true
}
variable "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  type        = string
  default = "10.10.10.0/24"
}

variable "vpc_id" {
  description = "VPC ID of an existing VPC to deploy pipeline into"
  type        = string
  default     = null
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "pipeline-vpc"
}

variable "subnet_a_cidr" {
  description = "CIDR block size for subnet A"
  type        = string
  default = "10.10.10.128/26"
}

variable "subnet_a_az" {
  description = "availability zone for subnet A"
  type        = string
  default = "us-east-1a"
}

variable "public_subnet_a_name" {
  description = "Name tag for public subnet A"
  type        = string
  default = "Public subnet A"
}

variable "subnet_b_cidr" {
  description = "CIDR block size for subnet B"
  type        = string
  default = "10.10.10.192/26"
}

variable "subnet_b_az" {
  description = "availability zone for subnet B"
  type        = string
  default = "us-east-1b"
}

variable "public_subnet_b_name" {
  description = "Name tag for public subnet B"
  type        = string
  default = "Public subnet B"
}

variable "subnet_c_cidr" {
  description = "CIDR block size for subnet C"
  type        = string
  default = "10.10.10.0/25"
}

variable "subnet_c_az" {
  description = "availability zone for subnet C"
  type        = string
  default = "us-east-1c"
}

variable "private_subnet_c_name" {
  description = "Name tag for public subnet C"
  type        = string
  default = "Private subnet C"
}

variable "igw_tag_name" {
  description = "Name tag internet gateway"
  type        = string
  default = "pipeline-vpc-igw"
}

variable "natgw_tag_name" {
  description = "Name tag nat  gateway"
  type        = string
  default = "pipeline-vpc-natgw"
}

variable "subnet_a_routetable_tag_name" {
  description = "Name tag for subnet a routetable"
  type        = string
  default = "Public subnet A routes"
}

variable "subnet_b_routetable_tag_name" {
  description = "Name tag for subnet b routetable"
  type        = string
  default = "Public subnet B routes"
}

variable "subnet_c_routetable_tag_name" {
  description = "Name tag for subnet c routetable"
  type        = string
  default = "Private subnet C routes"
}

variable "subnet_a_routetable_cidr" {
  description = "CIDR of traffic for route table"
  type        = string
  default = "0.0.0.0/0"
}

variable "subnet_b_routetable_cidr" {
  description = "CIDR of traffic for route table"
  type        = string
  default = "0.0.0.0/0"
}

variable "subnet_c_routetable_cidr" {
  description = "CIDR of traffic for route table"
  type        = string
  default = "0.0.0.0/0"
}

variable "ingress_ports" {
    description = "Ingress ports permitted for the codebuild security group"
    type = list
    default = [22, 443, 80]
}

variable "ingress_allowed_cidr" {
    description = "CIDR to allow ingress from"
    type = list(string)
    default = ["0.0.0.0/0"]
}

#----------------------------------------------------#
# Code Pipeline Vars
#----------------------------------------------------#

variable "branch" {
  description = "Branches to be built"
  type        = string
}

# variable "account_type" {
#   description = "Human readable name of the targets accounts"
#   type        = string
# }

#----------------------------------------------------#
# Code Commit Vars
#----------------------------------------------------#

variable "codecommit_repository_name" {
  description = "Name of a codecommit respository"
  type        = string
  default     = "packer-configuration"
}

variable "codecommit_repository_description" {
  description = "Description of the codecommit respository"
  type        = string
  default     = "Configurations to be applied by packer during the image build"
}

#----------------------------------------------------#
# Code Build Vars
#----------------------------------------------------#

#variable "codebuild_source_repository" {}

variable "buildspec_path" {
  description = "Path to the buildspec file"
  type        = string
}

variable "image" {
  description = "Container image for codebuild to use"
  type        = string

}
variable "type" {
  description = "What kind of image are you using? container or ?"
  type        = string

}
variable "compute_type" {
  description = "Size of the compute type to use"
  type        = string

}
variable "image_pull_credentials_type" {
  description = "Type of credentials to use to pull cotnainer image from registrry"
  type        = string
}

variable "build_timeout" {
  description = "Time elapsed before build forfiets"
  type        = string
}

variable "codebuild_project_name" {
  description = "Name of the codebuild project"
  type        = string
}

variable "codebuild_project_description" {
  description = "Description of the codebuild project"
  type        = string
}


#----------------------------------------------------#
# Alerts (SNS/Cloudwatch events) Vars
#----------------------------------------------------#
variable "sns_topic_name" {
  description = "Name of the SNS topic to be created"
  type        = string
}

variable "email_address" {
  description = "Email address to recieve snn notifcations."
  type        = string
}