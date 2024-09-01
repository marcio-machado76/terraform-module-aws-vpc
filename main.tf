locals {
  region                  = "us-east-1"
  cidr_vpc                = "10.10.0.0/16"
  count_available_subnets = 3
  tag_igw                 = "igw_example"
  route_table_tag         = "rt-example"
  create_nat_gateway      = false
  nat_gateway_name        = "natgw-example"
  nat-eip                 = "eip-example"
  subnet_indices_for_nat  = range(local.count_available_subnets)
  create_cluster = false
  cluster_name = "example-cluster-name" 
  

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = local.create_cluster ? "shared" : null
    "kubernetes.io/role/elb"                      = local.create_cluster ? "1" : null
  }
  
  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = local.create_cluster ? "shared" : null
    "kubernetes.io/role/internal-elb"             = local.create_cluster ? "1" : null
  }

  tags_vpc = {
    Name        = "vpc-example"
    Environment = "Production"
  }
}


module "vpc" {
  source                  = "./vpc"
  region                  = local.region
  cidr_vpc                = local.cidr_vpc
  count_available_subnets = local.count_available_subnets
  vpc                     = module.vpc.vpc
  tag_igw                 = local.tag_igw
  route_table_tag         = local.route_table_tag
  network_acl             = var.network_acl
  create_nat_gateway      = local.create_nat_gateway
  nat_gateway_name        = local.nat_gateway_name
  nat-eip                 = local.nat-eip
  subnet_indices_for_nat  = local.subnet_indices_for_nat
  tags_vpc                = local.tags_vpc
  public_subnet_tags      = local.public_subnet_tags
  private_subnet_tags     = local.private_subnet_tags
}
