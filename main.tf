provider "aws" {
  region = "ap-southeast-1"
}
module "kube_cluster1" {
  source  = "./kube_cluster"
}
output "nodes" {
  value = module.cluster.cluster_nodes
}
