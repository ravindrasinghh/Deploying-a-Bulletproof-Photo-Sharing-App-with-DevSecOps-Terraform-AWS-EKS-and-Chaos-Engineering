#!/bin/bash

# Dynamically fetch the AWS Account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ROLE_NAME="EksCodeBuildKubectlRole"

# Function to check if the IAM role exists
check_role_existence() {
    aws iam get-role --role-name $ROLE_NAME > /dev/null 2>&1
    echo $?
}

# Set the trust relationship policy JSON correctly
TRUST_POLICY='{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::'"${ACCOUNT_ID}"':root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}'

# Create IAM Role if it does not exist
if [ $(check_role_existence) -ne 0 ]; then
    echo "Creating IAM role..."
    aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document "$TRUST_POLICY"
else
    echo "Role already exists, skipping creation..."
fi

# Define inline policy for describing EKS resources
INLINE_POLICY='{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "eks:Describe*",
      "Resource": "*"
    }
  ]
}'

# File path for inline policy
POLICY_FILE="/tmp/iam-eks-describe-policy"
echo "$INLINE_POLICY" > $POLICY_FILE

# Attach the policy to the role
aws iam put-role-policy --role-name $ROLE_NAME --policy-name eks-describe --policy-document "file://$POLICY_FILE"

# Prepare the role definition for the aws-auth configmap
ROLE_DEF="  - rolearn: arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME}
    username: build
    groups:
      - system:masters"

# Get current aws-auth configMap data, check for existing role and append if not present
kubectl get configmap aws-auth -n kube-system -o yaml > /tmp/aws-auth-original.yml
if ! grep -q "$ROLE_NAME" /tmp/aws-auth-original.yml; then
    kubectl get -n kube-system configmap/aws-auth -o yaml | awk "/mapRoles: \|/{print;print \"$ROLE_DEF\";next}1" > /tmp/aws-auth-patch.yml
    kubectl patch configmap aws-auth -n kube-system --patch "$(cat /tmp/aws-auth-patch.yml)"
else
    echo "Role already in aws-auth, no changes made..."
fi

# Verify the updated configMap
kubectl get configmap aws-auth -o yaml -n kube-system
