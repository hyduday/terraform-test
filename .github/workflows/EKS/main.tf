provider "aws" {
  region = "ap-southeast-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "eks-vpc-u20"
  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  private_subnets = ["10.0.14.0/24", "10.0.15.0/24", "10.0.16.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "eks" {
  source             = "terraform-aws-modules/eks/aws"
  version            = "~> 21.0"
  name               = "my-eks-cluster-u20"
  kubernetes_version = "1.33"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group
  eks_managed_node_groups = {
    dev = {
      desired_size = 2
      max_size     = 3
      min_size     = 1

      instance_types = ["t3.medium"]

      tags = {
        Name = "dev-eks-node"
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
