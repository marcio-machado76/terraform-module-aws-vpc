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

