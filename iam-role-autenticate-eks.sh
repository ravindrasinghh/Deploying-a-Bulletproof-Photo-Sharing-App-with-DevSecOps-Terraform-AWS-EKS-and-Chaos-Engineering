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
ROLE_DEF="- rolearn: arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME}
  username: build
  groups:
    - system:masters"

# Get the current aws-auth ConfigMap and save it
TMP_FILE="/tmp/aws-auth.yml"
kubectl get configmap aws-auth -n kube-system -o yaml > $TMP_FILE

# Check if the role already exists in the ConfigMap
if ! grep -q "$ROLE_NAME" $TMP_FILE; then
    echo "Modifying aws-auth ConfigMap to add new role..."
    # Use yq to update the YAML file safely
    yq e '.data.mapRoles += "'"$ROLE_DEF"'"' -i $TMP_FILE
    # Add last-applied-configuration annotation using current content
    CONFIG=$(cat $TMP_FILE | yq e -j -)
    yq e '.metadata.annotations["kubectl.kubernetes.io/last-applied-configuration"]=$CONFIG' -i $TMP_FILE --arg CONFIG "$CONFIG"
    # Apply the updated ConfigMap
    kubectl apply -f $TMP_FILE
else
    echo "Role already in aws-auth, no changes made..."
fi

# Verify the updated ConfigMap
kubectl get configmap aws-auth -o yaml -n kube-system

