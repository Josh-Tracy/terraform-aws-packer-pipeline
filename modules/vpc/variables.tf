variable "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
}

variable "subnet_a_cidr" {
  description = "CIDR block size for subnet A"
  type        = string
}

variable "subnet_a_az" {
  description = "availability zone for subnet A"
  type        = string
}

variable "public_subnet_a_name" {
  description = "Name tag for public subnet A"
  type        = string
}

variable "subnet_b_cidr" {
  description = "CIDR block size for subnet B"
  type        = string
}

variable "subnet_b_az" {
  description = "availability zone for subnet B"
  type        = string
}

variable "public_subnet_b_name" {
  description = "Name tag for public subnet B"
  type        = string
}

variable "subnet_c_cidr" {
  description = "CIDR block size for subnet C"
  type        = string
}

variable "subnet_c_az" {
  description = "availability zone for subnet C"
  type        = string
}

variable "private_subnet_c_name" {
  description = "Name tag for public subnet C"
  type        = string
}

variable "igw_tag_name" {
  description = "Name tag internet gateway"
  type        = string
}

variable "natgw_tag_name" {
  description = "Name tag nat  gateway"
  type        = string
}

variable "subnet_a_routetable_tag_name" {
  description = "Name tag for subnet a routetable"
  type        = string
}

variable "subnet_b_routetable_tag_name" {
  description = "Name tag for subnet b routetable"
  type        = string
}

variable "subnet_c_routetable_tag_name" {
  description = "Name tag for subnet c routetable"
  type        = string
}

variable "subnet_a_routetable_cidr" {
  description = "CIDR of traffic for route table"
  type        = string
}

variable "subnet_b_routetable_cidr" {
  description = "CIDR of traffic for route table"
  type        = string
}

variable "subnet_c_routetable_cidr" {
  description = "CIDR of traffic for route table"
  type        = string
}

variable "sg_name_https" {
  description = "Name tag for security group that allows https"
  type        = string
}

variable "ingress_http_cidr" {
  description = "CIDR block of traffic allowed over http"
  type        = list
}

variable "http_ingress_rule_description" {
  description = "Description of http ingress rule"
  type        = string
}

variable "http_from_port" {
  description = "port to allow http ingress from"
  type        = number
}

variable "http_to_port" {
  description = "port to allow http ingress to"
  type        = number
}

variable "ingress_ssh_cidr" {
  description = "CIDR block of traffic allowed over ssh"
  type        = list
}

variable "ingress_https_cidr" {
  description = "CIDR block of traffic allowed over https"
  type        = list
}

variable "https_ingress_rule_description" {
  description = "Description of https ingress rule"
  type        = string
}

variable "https_from_port" {
  description = "port to allow https ingress from"
  type        = number
}

variable "https_to_port" {
  description = "port to allow https ingress to"
  type        = number
}

variable "ssh_ingress_rule_description" {
  description = "Description of ssh ingress rule"
  type        = string
}

variable "ssh_from_port" {
  description = "port to allow ssh ingress from"
  type        = number
}

variable "ssh_to_port" {
  description = "port to allow ssh ingress to"
  type        = number
}