# AWS VPC OpenTofu Module

This module provisions a **secure, multi-AZ Amazon Virtual Private Cloud (VPC)** using [OpenTofu](https://opentofu.org/) 

## 🧱 Key Features

- 🌐 **Multi-AZ VPC architecture** with public and private subnets evenly distributed
- 🔄 **Optional high-availability NAT Gateway support** (`enable_ha_ngw`) for resilient outbound access from private subnets
- 🔐 **Private subnet isolation** with no direct internet exposure
- 🧩 **Fully parameterized** to support reusable, multi-environment infrastructure (dev, staging, prod)
- 🏷️ **Custom subnet tagging** for Kubernetes integration (e.g., internal/public load balancer roles)

## ✅ Use Cases

- Provision a reliable VPC foundation for EKS, RDS, ALB, and other AWS services
- Separate public-facing services from private workloads securely
- Enable scalable, fault-tolerant architecture across multiple AZs

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.ha_ngw_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip.non_ha_ngw_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.ha_ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_nat_gateway.non_ha_ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_rt_associations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | A boolean flag to enable/disable DNS support in the VPC. | `bool` | n/a | yes |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | A boolean flag to enable/disable DNS support in the VPC. | `bool` | n/a | yes |
| <a name="input_enable_ha_ngw"></a> [enable\_ha\_ngw](#input\_enable\_ha\_ngw) | A boolean flag to enable/disable a high availability setting for the NAT Gateway. | `bool` | n/a | yes |
| <a name="input_enable_karpenter_fargate"></a> [enable\_karpenter\_fargate](#input\_enable\_karpenter\_fargate) | Boolean toggle to enable the EKS Fargate for the Karpenter namespace. | `bool` | `false` | no |
| <a name="input_enable_managed_nodegroup"></a> [enable\_managed\_nodegroup](#input\_enable\_managed\_nodegroup) | Boolean toggle to enable the default managed nodegroup. | `bool` | `true` | no |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | Public subnet CIDRs to use in the AWS VPC | `list(string)` | n/a | yes |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | Tags to add to private subnets. | `map(any)` | `{}` | no |
| <a name="input_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#input\_public\_subnet\_cidrs) | Public subnet CIDRs to use in the AWS VPC | `list(string)` | n/a | yes |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | Tags to add to public subnets. | `map(any)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The CIDR to use for the AWS VPC. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | The IDs of the provisioned private subnets |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | The IDs of the provisioned public subnets |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The AWS given ID of the provisioned VPC |
<!-- END_TF_DOCS -->