# eks variables

# AWS access key used to create infrastructure
variable "aws_access_key" {
 type     = string
 description = "AWS access key"
}

# AWS secret key used to create infrastructure
variable "aws_secret_key" {
 type     = string
 description = "AWS secret key"
}

# AWS region used for all resources
variable "aws_region" {
 type     = string
 description = "AWS availability zone 1 for the aws_region"
}

variable "aws_az1" {
  type = string
  description = "AWS availability zone 1 for the aws_region"
}

variable "aws_az2" {
  type = string
  description = "AWS availability zone 2 for the aws_region"
}

# Prefix of the resources that will be created under this module
variable "resource_prefix" {
 type     = string
 description = "prefix of the resources that will be created under this module"
}

# aks variables
variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}
variable "location" {
  type        = string
  description = "Resources location in Azure"
}
variable "cluster_name" {
  type        = string
  description = "AKS name in Azure"
}
variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}
variable "system_node_count" {
  type        = number
  description = "Number of AKS worker nodes"
}
variable "client_id" { }
variable "client_secret" { }
variable "subscription_id" { }
variable "tenant_id" { }
variable "acr_name" { }

# gke variables
variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}
