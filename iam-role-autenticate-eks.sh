#!/bin/bash

# Retrieve Account ID securely
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Define Trust Policy document with least privilege for security
TRUST="{
  \"Version\": \"2012-10-17\",
  \"Statement\": [
    {
      \"Effect\": \"Allow\",
      \"Principal\": {
        \"AWS\": \"arn:aws:iam::${ACCOUNT_ID}:root\"
      },
      \"Action\": \"sts:AssumeRole\"
    }
  ]
}"

# Create IAM Role for CodeBuild with informative error handling
ROLE_ARN=$(aws iam create-role \
  --role-name EksCodeBuildKubectlRole \
  --assume-role-policy-document "$TRUST" \
  --query 'Role.Arn' --output text 2>/dev/null)

if [ -z "$ROLE_ARN" ]; then
  echo "Error creating IAM role EksCodeBuildKubectlRole. Check AWS CLI configuration and IAM permissions."
  exit 1
fi

# Define Inline Policy document with limited actions for security
POLICY='{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "eks:DescribeCluster",
        "eks:DescribeClusterKubernetesVersion",
        "eks:ListClusters",
        "eks:DescribeNodepool",
        "eks:ListNodepools",
        "iam:GetRole",
        "sts:GetCallerIdentity"
      ],
      "Resource": "*"
    }
  ]
}'

# Associate Inline Policy to the role with error handling
aws iam put-role-policy --role-name EksCodeBuildKubectlRole --policy-name eks-describe --policy-document "$POLICY"
if [ $? -ne 0 ]; then
  echo "Error associating policy eks-describe to EksCodeBuildKubectlRole."
  exit 1
fi

# Get current aws-auth configmap data (use yq for robustness)
CURRENT_CONFIG=$(kubectl get configmap aws-auth -n kube-system -o yaml | yq -r .)

# Define new role information for patching (use yq for clarity)
NEW_ROLE="
  - rolearn: $ROLE_ARN
    username: build
    groups:
      - system:masters  # Consider reducing privileges if possible
"

# Patch the aws-auth configmap with the new role using yq
yq -y '.data.mapRoles[] += ("'"$NEW_ROLE"'" )' -i <(echo "$CURRENT_CONFIG") | kubectl patch configmap/aws-auth -n kube-system -p -

# Check for patching errors
if [ $? -ne 0 ]; then
  echo "Error patching aws-auth configmap."
  exit 1
fi

echo "EksCodeBuildKubectlRole created and aws-auth configmap updated successfully!"
