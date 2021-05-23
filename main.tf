provider "aws" {
  region = "ap-southeast-1"
}
module "kube_cluster1" {
  source  = "./kube_cluster1"
}
output "nodes" {
  value = module.kube_cluster1.cluster_nodes
}
