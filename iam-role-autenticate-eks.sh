#!/bin/bash

set -euo pipefail

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ROLE_NAME="EksCodeBuildKubectlRole"

check_role_existence() {
    aws iam get-role --role-name $ROLE_NAME &>/dev/null
}

TRUST_POLICY=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "AWS": "arn:aws:iam::$ACCOUNT_ID:root"
    },
    "Action": "sts:AssumeRole"
  }]
}
EOF
)

if ! check_role_existence; then
    echo "Creating IAM role..."
    aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document "$TRUST_POLICY"
else
    echo "Role already exists, skipping creation."
fi

INLINE_POLICY=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": "eks:Describe*",
    "Resource": "*"
  }]
}
EOF
)

POLICY_FILE="/tmp/iam-eks-describe-policy.json"
echo "$INLINE_POLICY" > $POLICY_FILE

aws iam put-role-policy --role-name $ROLE_NAME --policy-name eks-describe --policy-document "file://$POLICY_FILE"

ROLE_DEF="{
  \"op\": \"add\",
  \"path\": \"/data/mapRoles\",
  \"value\": \"  - rolearn: arn:aws:iam::$ACCOUNT_ID:role/$ROLE_NAME\n    username: build\n    groups:\n      - system:masters\"
}"

kubectl get configmap aws-auth -n kube-system -o yaml > /tmp/aws-auth-original.yml

if ! grep -q "$ROLE_NAME" /tmp/aws-auth-original.yml; then
    kubectl patch configmap/aws-auth --type=json -n kube-system --patch "[$ROLE_DEF]"
else
    echo "Role already in aws-auth, no changes made."
fi

kubectl get configmap aws-auth -o yaml -n kube-system
