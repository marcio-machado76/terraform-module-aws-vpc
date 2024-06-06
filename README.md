# terraform-module-aws-vpc
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/Amazon_AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
- [x] Status:  Ainda em desenvolvimento.
###
### Módulo para criar uma VPC na AWS composta dos recursos, Vpc, subnets (publicas e privadas), network Acls, route tables e internet gateway. Para utilizar este módulo é necessário os seguintes arquivos especificados logo abaixo:

   <summary>provider.tf - Arquivo com os providers.</summary>

```hcl
provider "aws" {
  region = local.region
  default_tags {
    tags = {
      Terraform = "true"
      Owner     = "sre/devops"
      Project   = "lab-devops"
    }
  }
}
```

   <summary>versions.tf - Arquivo com as versões dos providers.</summary>

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```
#
<summary>main.tf - Arquivo que irá consumir o módulo para criar a infraestrutura.</summary>

```hcl
locals {
  region                  = "us-east-1"
  cidr_vpc                = "10.10.0.0/16"
  count_available_subnets = 3 # Quantidade de subnets publicas e privadas que deseja criar
  tag_igw                 = "igw_devops"
  route_table_tag         = "rt-devops"
  create_nat_gateway      = false # Criar Nat Gateway "true ou false"
  nat_gateway_name        = "natgw-devops"
  nat-eip                 = "eip-devops"
  subnet_indices_for_nat  = [0] # indice de acordo com a quantidade de subnets e nat gateway que deseja criar, ex: [0, 1, 2]
  tags_vpc = {
    Name        = "vpc-devops"
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
}
```
#
<summary>variables.tf - Arquivo que contém as variáveis que o módulo irá utilizar e pode ter os valores alterados de acordo com a necessidade.</summary>

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
#
<summary>outputs.tf - Outputs de recursos que podem ser utilizados em outros módulos.</summary>

```hcl
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

```


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

#
## Como usar.
  - Para utilizar localmente baixe o repositório e ajuste o bloco `locals` dentro de `main.tf` de acordo com a necessidade de região e configurações dos recursos como range de ip da vpc, quantidade de subnets, etc.
  - O `backend.tf`, caso necessite será preciso criar um bucket S3 e uma tabela no dynamodb para armazenar o tfstate do módulo, mas caso queira testar sem é só comentar ou deletar o arquivo.
  - Após criar os arquivos, atente-se aos valores default das variáveis e também em `locals` dentro do `main.tf`, pois podem ser alterados de acordo com sua necessidade.
  - No caso em `locals` a variável `create_nat_gateway` esta como `false`, mas caso necessite que a subnet privada tenha saída para internet é só alterar para `true` e na variável `subnet_indices_for_nat`, pode-se
    ajustar o índice como comentado no próprio arquivo, como por exemplo, caso tenha 3 subnets e queira um nat para cada uma delas é só ajustar no array [0, 1, 2].
  - Ainda dentro de `locals` a variável `count_available_subnets` define o quantidade de zonas de disponibilidade, públicas e privadas que seram criadas nessa Vpc.
  - Certifique-se que possua as credenciais da AWS - **`AWS_ACCESS_KEY_ID`** e **`AWS_SECRET_ACCESS_KEY`**.

### Comandos
Para utilizar o módulo deste repositório é necessário ter o terraform instalado ou utilizar o container do terraform dentro da pasta do seu projeto da seguinte forma:

* `docker run -it --rm -v $PWD:/app -w /app --entrypoint "" hashicorp/terraform:light sh` 
    
Em seguida exporte as credenciais da AWS:

* `export AWS_ACCESS_KEY_ID=sua_access_key_id`
* `export AWS_SECRET_ACCESS_KEY=sua_secret_access_key`
  
- Obs: O export das credenciais é somente um exemplo para fins de testes.
    
Agora é só executar os comandos do terraform:

* `terraform init` - Comando irá baixar todos os modulos e plugins necessários.
* `terraform fmt` - Para verificar e formatar a identação dos arquivos.
* `terraform validate` - Para verificar e validar se o código esta correto.
* `terraform plan` - Para criar um plano de todos os recursos que serão utilizados.
* `terraform apply` - Para aplicar a criação/alteração dos recursos. 
* `terraform destroy` - Para destruir todos os recursos que foram criados pelo terraform. 
