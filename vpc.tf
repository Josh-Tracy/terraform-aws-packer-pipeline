module "vpc" {
  source                = "./modules/vpc"                    # relative path to the vpc module
  vpc_cidr_block        = "10.10.10.0/24"                    # CIDR Block for the VPC
  vpc_name              = "Packer CI CD Test" # Name of the VPC
  subnet_a_cidr         = "10.10.10.128/26"                  # Subnet A CIDR
  subnet_a_az           = "us-west-2a"                       # Subnet A AZ
  public_subnet_a_name  = "Public subnet A"                  # Subnet A Name
  subnet_b_cidr         = "10.10.10.192/26"                  # Subnet B CIDR
  subnet_b_az           = "us-west-2b"                       # Subnet B AZ
  public_subnet_b_name  = "Public subnet B"                  # Subnet B Name
  subnet_c_cidr         = "10.10.10.0/25"                    #Subnet C CIDR
  subnet_c_az           = "us-west-2c"                       #Subnet C AZ
  private_subnet_c_name = "Private subnet C"                 # Subnet C Name
  # Internet Gateway settings
  ig_tag_name = "Packer CI CD Test Internet Gateway" # Tag name to be applied to the Internet GW
  # NAT Gateway settings
  natgw_tag_name = "Packer CI CD Test NAT Gateway" # Tag name to be applied to the NAT GW
  # Routing Settings
  subnet_a_routetable_tag_name = "Public subnet A routes"  # Route Table for subnet A Name
  subnet_b_routetable_tag_name = "Public subnet B routes"  # Route Table for subnet B Name
  subnet_c_routetable_tag_name = "Private subnet C routes" # Route Table for subnet C Name
  subnet_a_routetable_cidr     = "0.0.0.0/0"               # Route Table for subnet A CIDR
  subnet_b_routetable_cidr     = "0.0.0.0/0"               # Route Table for subnet B CIDR
  subnet_c_routetable_cidr     = "0.0.0.0/0"               # Route Table for subnet C CIDR
}