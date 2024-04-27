# # Inside the module (e.g., outputs.tf within the module directory)
# output "cluster_id" {
#   value = aws_eks_cluster.this.id
# }

# output "oidc_issuer" {
#   value = aws_eks_cluster.this.identity[0].oidc[0].issuer
# }