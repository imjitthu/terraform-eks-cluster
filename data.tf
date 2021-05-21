terraform {
  backend "s3" {
    bucket = "terraform-state-jithendar"
    key    = "eks-cluster.tfstate"
    region = "us-east-1"
  }
}