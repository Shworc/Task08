#!/bin/bash
source "../../../shared_libs/shell_functions.sh" &>/dev/null
load_vars_from_json_file "../infra/input.json"
load_vars_from_json_file "../infra/output.json"

# Set credentials
az login --service-principal -u "${ARM_CLIENT_ID}" -p "${ARM_CLIENT_SECRET}" --tenant "${ARM_TENANT_ID}" >/dev/null
az account set --subscription "${ARM_SUBSCRIPTION_ID}"

bash ../../../scripts/env2template/main.sh terraform.tfvars.tpl terraform.tfvars

terraform init

if [ "$1" == "up" ]; then
  # Archive the application directory into a tar.gz file
  tar -czvf app.tar.gz -C ../solution/application .

  # Set variables
  SA_NAME="app${custom_identifier}sa"
  RESOURCE_GROUP_NAME="app-${custom_identifier}-rg"
  LOCATION="eastus"
  CONTAINER_NAME="app-content"
  BLOB_NAME="app.tar.gz"
  START_TIME="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  EXPIRY_TIME="$(date -u -d '+1 year' +%Y-%m-%dT%H:%M:%SZ)"

  az group create --name $RESOURCE_GROUP_NAME --location $LOCATION
  # Create a storage account
  az storage account create \
    --name $SA_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --location $LOCATION \
    --sku Standard_LRS \
    --enable-hierarchical-namespace false \
    --enable-sftp false

  # Retrieve the storage account connection string
  CONN_STRING=$(az storage account show-connection-string \
    --name $SA_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --query connectionString \
    --output tsv)

  # Create a storage container
  az storage container create \
    --name $CONTAINER_NAME \
    --account-name $SA_NAME \
    --connection-string "$CONN_STRING" \
    --public-access off

  # Upload the blob (app.tar.gz) to the container
  az storage blob upload \
    --container-name $CONTAINER_NAME \
    --name $BLOB_NAME \
    --file ./app.tar.gz \
    --account-name $SA_NAME \
    --connection-string "$CONN_STRING"

  # Generate a SAS token for the container
  export TF_VAR_git_pat=$(az storage container generate-sas \
    --name $CONTAINER_NAME \
    --account-name $SA_NAME \
    --connection-string "$CONN_STRING" \
    --permissions lr \
    --https-only \
    --start $START_TIME \
    --expiry $EXPIRY_TIME \
    --output tsv)

  export TF_VAR_context_repo_path="https://$SA_NAME.blob.core.windows.net/$CONTAINER_NAME/app.tar.gz"

  jq --arg git_pat "$TF_VAR_git_pat" --arg repo_path "$TF_VAR_context_repo_path" '. + {"TF_VAR_git_pat": $git_pat, "TF_VAR_context_repo_path": $repo_path}' "../../${task_name}/infra/input.json" > "../../${task_name}/infra/tmp.json" && mv "../../${task_name}/infra/tmp.json" "../../${task_name}/infra/input.json"

  rm -rf "app.tar.gz"
  terraform apply -auto-approve
elif [ "$1" == "down" ]; then
  terraform destroy -auto-approve
  az group exists -n ${RESOURCE_GROUP_NAME} && az group delete -n ${RESOURCE_GROUP_NAME} --yes
else
  echo "Usage: $0 {up|down}"
  exit 1
fi
