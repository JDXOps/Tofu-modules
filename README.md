# 🧱 OpenTofu AWS Infrastructure Modules

This project is a growing collection of modular, production-grade [OpenTofu](https://opentofu.org/) modules for provisioning foundational AWS infrastructure.

The goal is to provide a flexible, reusable toolkit for building secure and scalable cloud environments — including networking (VPCs, subnets, NAT), IAM roles and policies, logging, DNS, and other core infrastructure components.

Each module is composable, environment-agnostic and easily integrates into any project.

## Module List 

- [`vpc`](./modules/vpc) – Provisions Multi AZ VPC with Public and Private Subnets
- [`rds`](./modules/vpc) – Provisions Classic RDS DB Instance (no aurora)
