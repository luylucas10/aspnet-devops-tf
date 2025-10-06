az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<ID>"

# {
#   "appId": "",
#   "displayName": "",
#   "password": "",
#   "tenant": ""
# }

# Set the environment variables for Terraform
export TF_VAR_subscription_id=""
export TF_VAR_client_id=""
export TF_VAR_client_secret=""
export TF_VAR_tenant_id=""

# Initialize Terraform
terraform init

# Plan the Terraform deployment
terraform plan

# Apply the Terraform deployment
terraform apply