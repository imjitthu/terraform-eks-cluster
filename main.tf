locals {
  key_name = ""
  key_path = ""
}

data "aws_eks_cluster" "test_eks_cluster" {
  name = module.test_eks_cluster.cluster_id
}

data "aws_eks_cluster_auth" "test_eks_cluster" {
  name = module.test_eks_cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

module "test_eks_cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "test_eks_cluster"
  cluster_version = "1.17"
  subnets         = ["", ""]
  vpc_id          = ""

node_groups = {
  public = {
    subnets          = [""]
    desired_capacity = 1
    max_capacity     = 10
    min_capacity     = 1

    instance_type    = "t2.small"
    k8s_lables       = {
      Environment    = "public"
    }
  }
 private = {
    subnets          = [""]
    desired_capacity = 1
    max_capacity     = 10
    min_capacity     = 1

    instance_type    = "t2.small"
    k8s_lables       = {
      Environment    = "private"
    }
  }
}

