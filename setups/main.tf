provider "aws" {
  profile = "terraform"
  region  = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "provision_eks_cluster" {
    source = "../cloud_provider/eks"
    aws_access_key = var.aws_access_key
    aws_secret_key = var.aws_secret_key
    aws_region = var.aws_region
    aws_az1 = var.aws_az1
    aws_az2 = var.aws_az2
    resource_prefix = var.resource_prefix
}

module "provision_aks_cluster" {
    source = "../cloud_provider/aks"
    resource_group_name = var.resource_group_name
    location = var.location
    cluster_name = var.cluster_name
    kubernetes_version = var.kubernetes_version
    system_node_count = var.system_node_count
    acr_name = var.acr_name
    client_id = var.client_id
    client_secret = var.client_secret
    subscription_id = var.subscription_id
    tenant_id = var.tenant_id
}
