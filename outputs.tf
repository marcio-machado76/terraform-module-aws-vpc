output "vpc" {
  description = "Idendificador da VPC"
  value       = module.vpc.vpc
}

output "public_subnet" {
  description = "Subnet public "
  value       = module.vpc.public_subnet
}

output "private_subnet" {
  description = "Subnet private "
  value       = module.vpc.private_subnet
}

output "vpc_arn" {
  description = "ARN da VPC"
  value       = module.vpc.vpc_arn
}


output "igw_id" {
  description = "ID do Internet Gateway"
  value       = module.vpc.igw_id
}

output "igw_arn" {
  description = "ARN do Internet Gateway"
  value       = module.vpc.igw_arn
}

output "nat_ids" {
  description = "Lisa de allocation ID de Elastic IPs criados para AWS NAT Gateway"
  value       = module.vpc.nat_ids
}



output "natgw_ids" {
  description = "ID do Nat Gateway"
  value       = module.vpc.natgw_ids
}

output "natgw_interface_ids" {
  description = "ID da interface associada ao NAT Gateways"
  value       = module.vpc.natgw_interface_ids
}


