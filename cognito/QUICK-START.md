# Cognito Quick Start Guide

Quick reference for deploying the Cognito infrastructure.

## Prerequisites

1. AWS credentials configured
2. Existing S3 bucket and DynamoDB table for Terraform state
3. Information about existing Cognito resources (if importing)

## Initial Setup

### 1. Create Variable File

```bash
# For HML environment
cp hml.tfvars.example hml.tfvars

# Edit hml.tfvars and fill in the values
```

**Required values**:
- `cognito_domain_prefix` - Your Cognito domain prefix (must be globally unique)
- `user_pool_name` - Your User Pool name (optional, will use default if not set)

### 2. Initialize Terraform

```bash
terraform init -backend-config=backend-hml.hcl
```

### 3. Import Existing Resources (if applicable)

Get your existing resource IDs:

```bash
# List User Pools
aws cognito-idp list-user-pools --max-results 20

# List App Clients
aws cognito-idp list-user-pool-clients --user-pool-id <USER_POOL_ID>
```

Use the helper script:

```bash
bash import-resources.sh hml
```

Or run import commands manually (see README.md).

### 4. Validate Configuration

```bash
# Check what Terraform will do
terraform plan -var-file=hml.tfvars

# Should show NO resource recreation after import
```

### 5. Apply Configuration

```bash
terraform apply -var-file=hml.tfvars
```

## For Production Environment

Replace `hml` with `prd` in all commands above:

```bash
cp prd.tfvars.example prd.tfvars
terraform init -backend-config=backend-prd.hcl
bash import-resources.sh prd
terraform plan -var-file=prd.tfvars
terraform apply -var-file=prd.tfvars
```

## Outputs

After apply, get the configuration values:

```bash
terraform output
```

Key outputs:
- `cognito_token_endpoint` - OAuth2 token endpoint URL
- `cognito_client_id` - App client ID (non-sensitive)
- `cognito_secret_name` - AWS Secrets Manager secret name

## For Applications

### Lambda/API Configuration

Set these environment variables:

```bash
COGNITO_SECRET_ID=mechermes-hml-cognito-credentials  # From cognito_secret_name output
```

Applications should:
1. Read the secret from AWS Secrets Manager using the secret name
2. Extract `client_id` and `client_secret` from the JSON
3. Use the token endpoint to obtain access tokens

## Troubleshooting

**Problem**: Terraform wants to destroy and recreate resources

**Solution**: Ensure you've imported all existing resources correctly

**Problem**: Domain already exists error

**Solution**: Use the exact same domain prefix from your existing Cognito setup

**Problem**: Access denied to Secrets Manager

**Solution**: Grant IAM permissions to the consuming application:
```json
{
  "Effect": "Allow",
  "Action": ["secretsmanager:GetSecretValue"],
  "Resource": "arn:aws:secretsmanager:us-east-1:*:secret:mechermes-*-cognito-credentials-*"
}
```

## Next Steps

1. Update Lambda/API to use the new secret from Secrets Manager
2. Test authentication flow in HML
3. Repeat process for PRD environment
4. Remove any hardcoded credentials from applications

For detailed documentation, see [README.md](./README.md)
