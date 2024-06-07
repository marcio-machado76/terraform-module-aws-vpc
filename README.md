# terraform-module-aws-vpc
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/Amazon_AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
- [x] Status:  Ainda em desenvolvimento.
###
#### Módulo para criar uma VPC na AWS composta dos recursos, Vpc, subnets (publicas e privadas), network Acls, route tables e internet gateway. 




#
<summary>main.tf - Exemplo de utilização do módulo configurando os valores no bloco locals.</summary>

```hcl
locals {
  region                  = "us-east-1"
  cidr_vpc                = "10.10.0.0/16"
  count_available_subnets = 3 
  tag_igw                 = "igw_example"
  route_table_tag         = "rt-example"
  create_nat_gateway      = false 
  nat_gateway_name        = "natgw-example"
  nat-eip                 = "eip-example"
  subnet_indices_for_nat  = [0]
  tags_vpc = {
    Name        = "vpc-example"
    Environment = "Production"
  }
  
  public_subnet_tags = {
    # "kubernetes.io/cluster/cluster_name" = "shared"
    # "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    # "kubernetes.io/cluster/cluster_name" = "shared"
    # "kubernetes.io/role/internal-elb" = "1"
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
  public_subnet_tags = local.public_subnet_tags
  private_subnet_tags = local.private_subnet_tags
}
```
#
<summary>variables.tf - Para Network ACLs segue exemplo da variável liberando algumas portas e protoolos.</summary>

```hcl
variable "network_acl" {
  description = "Regras de Network Acls AWS"
  type        = map(object({ protocol = string, action = string, cidr_blocks = string, from_port = number, to_port = number }))
  default = {
    100 = { protocol = "tcp", action = "allow", cidr_blocks = "0.0.0.0/0", from_port = 22, to_port = 22 }
    105 = { protocol = "tcp", action = "allow", cidr_blocks = "0.0.0.0/0", from_port = 80, to_port = 80 }
    110 = { protocol = "tcp", action = "allow", cidr_blocks = "0.0.0.0/0", from_port = 443, to_port = 443 }
    150 = { protocol = "tcp", action = "allow", cidr_blocks = "0.0.0.0/0", from_port = 1024, to_port = 65535 }
  }
}
```
#### Comandos Terraform
Para utilizar o módulo deste repositório, siga os seguintes passos:
* 1 - Clone o repositório para o seu ambiente local.
* 2 - Configure as credenciais da AWS exportando AWS_ACCESS_KEY_ID e AWS_SECRET_ACCESS_KEY. (Obs: O export das credenciais é somente um exemplo para fins de testes.)
* 3 - Execute os comandos Terraform:
```sh
terraform init
terraform plan
terraform apply
```

### Instruções Adicionais
* Ajuste o bloco locals dentro do arquivo main.tf conforme necessário para configurar a região e outros detalhes da infraestrutura.
* Certifique-se de configurar um bucket S3 e uma tabela DynamoDB para armazenar o tfstate do módulo, se necessário.
* Revise e ajuste os valores padrão das variáveis e dos locais conforme sua necessidade.
* Certifique-se de possuir as credenciais da AWS corretamente configuradas e o terraform instalado.
* Também é possível utilizar o container do terraform dentro da pasta do seu projeto da seguinte forma:
  - `docker run -it --rm -v $PWD:/app -w /app --entrypoint "" hashicorp/terraform:light sh` 


### Estrutura do Projeto
* `main.tf`: Arquivo principal que consome o módulo para criar a infraestrutura.
* `variables.tf`: Arquivo contendo as variáveis utilizadas pelo módulo.
* `outputs.tf`: Arquivo contendo as saídas de recursos que podem ser utilizadas em outros módulos.
* `provider.tf`: Arquivo com os providers necessários.
* `versions.tf`: Arquivo com as versões dos providers.

### Recursos Criados
* VPC
* Subnets (públicas e privadas)
* Network ACLs
* Route tables
* Internet Gateway
* Nat Gateway (opcional)

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_network_acl.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_vpc"></a> [cidr\_vpc](#input\_cidr\_vpc) | cidr\_vpc da VPC | `string` | n/a | yes |
| <a name="input_count_available_subnets"></a> [count\_available\_subnets](#input\_count\_available\_subnets) | Numero de Zonas de disponibilidade | `number` | n/a | yes |
| <a name="input_create_nat_gateway"></a> [create\_nat\_gateway](#input\_create\_nat\_gateway) | true ou false de acordo com a necessidade | `bool` | n/a | yes |
| <a name="input_nat-eip"></a> [nat-eip](#input\_nat-eip) | name para eip | `string` | n/a | yes |
| <a name="input_nat_gateway_name"></a> [nat\_gateway\_name](#input\_nat\_gateway\_name) | nat gateway name | `string` | n/a | yes |
| <a name="input_network_acl"></a> [network\_acl](#input\_network\_acl) | Regras de network acl | `map(any)` | n/a | yes |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | n/a | `any` | n/a | yes |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | n/a | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Região na AWS | `string` | n/a | yes |
| <a name="input_route_table_tag"></a> [route\_table\_tag](#input\_route\_table\_tag) | Tag Name das route tables | `string` | n/a | yes |
| <a name="input_subnet_indices_for_nat"></a> [subnet\_indices\_for\_nat](#input\_subnet\_indices\_for\_nat) | Quantidade a ser criado de acordo com a necessidade fornecendo o indice da quantidade de subnets | `list(number)` | n/a | yes |
| <a name="input_tag_igw"></a> [tag\_igw](#input\_tag\_igw) | Tag Name do internet gateway | `string` | n/a | yes |
| <a name="input_tags_vpc"></a> [tags\_vpc](#input\_tags\_vpc) | Tags para VPC | `map(string)` | n/a | yes |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | Id da VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_subnet"></a> [private\_subnet](#output\_private\_subnet) | Subnet private |
| <a name="output_public_subnet"></a> [public\_subnet](#output\_public\_subnet) | Subnet public |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | Idendificador da VPC |
| <a name="output_vpc_cidrblock"></a> [vpc\_cidrblock](#output\_vpc\_cidrblock) | Idendificador da VPC |
