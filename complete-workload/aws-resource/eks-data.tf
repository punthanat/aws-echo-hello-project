data "aws_eks_cluster" "selected" {
  depends_on = [module.eks]
  name       = module.eks.cluster_id
}
data "aws_eks_cluster_auth" "selected" {
  depends_on = [module.eks]
  name       = module.eks.cluster_id
}

