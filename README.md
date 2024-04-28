![CICD](docs/secops.png)

**Step 1:** 
After successfully creating the infrastructure, add and install the Nginx Ingress Controller and repository using the following Helm commands:    
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx --version 4.10.0 --namespace ingress-nginx --create-namespace --set controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-ssl-cert"="acm-cert-arn" -f nginx-config.yaml
```
You can also customize the Nginx value: [https://github.com/kubernetes/ingress-nginx]

**Step 2:** Run a bash script to create and authenticate CodeBuild with AWS EKS and update the EKS cluster's aws-auth ConfigMap with the new role.
1. chmod +x `iam-role-autenticate-eks.sh`
2. `./iam-role-autenticate-eks.sh`

![CICD](docs/secops.png)

**Step 1:** 
After successfully creating the infrastructure, add and install the Nginx Ingress Controller and repository using the following Helm commands:    
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx --version 4.10.0 --namespace ingress-nginx --create-namespace --set controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-ssl-cert"="acm-cert-arn" -f nginx-config.yaml
```
You can also customize the Nginx value: [https://github.com/kubernetes/ingress-nginx]

**Step 2:** Run a bash script to create and authenticate CodeBuild with AWS EKS and update the EKS cluster's aws-auth ConfigMap with the new role.
1. chmod +x `iam-role-autenticate-eks.sh`
2. `./iam-role-autenticate-eks.sh`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.29.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.6.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >= 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.47.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm_backend"></a> [acm\_backend](#module\_acm\_backend) | terraform-aws-modules/acm/aws | 4.0.1 |
| <a name="module_acm_cf"></a> [acm\_cf](#module\_acm\_cf) | terraform-aws-modules/acm/aws | 4.0.1 |
| <a name="module_ui"></a> [ui](#module\_ui) | terraform-aws-modules/s3-bucket/aws | 3.3.0 |
| <a name="module_ui-cf"></a> [ui-cf](#module\_ui-cf) | terraform-aws-modules/cloudfront/aws | 3.4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.photos_metadata](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_ecr_repository.foo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.private-nodes-01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.private-nodes-02](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_policy.node_additional_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.demo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.demo-AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node-additional-permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.nodes-EC2RoleForSSM](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.nodes-SSMFullAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.nodes-SSMManagedInstanceCore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.nodes-SessionManager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_kms_key.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_nat_gateway.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private-ap-south-1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private-ap-south-1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public-ap-south-1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public-ap-south-1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private-ap-south-1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private-ap-south-1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public-ap-south-1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public-ap-south-1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_wafv2_ip_set.block_ip_set](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_web_acl.main_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_config"></a> [cluster\_config](#input\_cluster\_config) | Configuration for the cluster, detailing specifics like size, type, and other cluster-related settings. | `any` | n/a | yes |
| <a name="input_ecr_names"></a> [ecr\_names](#input\_ecr\_names) | Names of the Elastic Container Registry repositories required for the deployment. | `any` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | The deployment environment name, e.g., 'prod', 'dev', or 'test'. | `string` | n/a | yes |
| <a name="input_ui_conf"></a> [ui\_conf](#input\_ui\_conf) | UI configuration settings, which may include theming, layout, and feature toggles. | `any` | n/a | yes |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Configuration parameters for the VPC including subnets, CIDR blocks, and other network-related settings. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_arn"></a> [acm\_arn](#output\_acm\_arn) | n/a |
| <a name="output_cloudfront_url"></a> [cloudfront\_url](#output\_cloudfront\_url) | The URL of the CloudFront distribution. |
| <a name="output_dynamodb_table_name"></a> [dynamodb\_table\_name](#output\_dynamodb\_table\_name) | The name of the DynamoDB table. |
| <a name="output_ecr_repository_details"></a> [ecr\_repository\_details](#output\_ecr\_repository\_details) | Details of the ECR repositories including URLs and ARNs |
| <a name="output_eks_values_private_nodes_01"></a> [eks\_values\_private\_nodes\_01](#output\_eks\_values\_private\_nodes\_01) | Values related to the AWS EKS managed node group for private-nodes-01 |
| <a name="output_eks_values_private_nodes_02"></a> [eks\_values\_private\_nodes\_02](#output\_eks\_values\_private\_nodes\_02) | Values related to the AWS EKS managed node group for private-nodes-02 |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | The name of the S3 bucket. |
| <a name="output_vpc_details"></a> [vpc\_details](#output\_vpc\_details) | Details of the main VPC |
