# resource "helm_release" "aws-load-balancer-controller" {
#   name             = "aws-load-balancer-controller"
#   repository       = "https://aws.github.io/eks-charts"
#   chart            = "aws-load-balancer-controller"
#   namespace        = "kube-system"
#   version          = "1.4.1"
#   create_namespace = true

#   values = [
#     file("configs/ingress.yaml")
#   ]
#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = aws_iam_role.aws-load-balancer-controller.arn
#   }
# }