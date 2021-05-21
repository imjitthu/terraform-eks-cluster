resource "aws_vpc" "test_eks_vpc" {
  cidr_block = "${var.VPC_CIDR}"
  tags = {
    "Name" = "eks_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.test_eks_vpc.id
  cidr_block = "${var.PUB_SUB_CIDR}"
  availability_zone = ""
  map_public_ip_on_launch = "true" #it makes this a public subnet
  tags = {
    "Name" = "public_eks_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.test_eks_vpc.id
  cidr_block = "${var.PRI_SUB_CIDR}"
  availability_zone = ""
  tags = {
    "Name" = "private_eks_subnet"
  }
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

    instance_type    = "${var.INSTANCE_TYPE}"
    k8s_lables       = {
      Environment    = "public"
    }
  }
 private = {
    subnets          = [""]
    desired_capacity = 1
    max_capacity     = 10
    min_capacity     = 1

    instance_type    = "${var.INSTANCE_TYPE}"
    k8s_lables       = {
      Environment    = "private"
    }
  }
}

