terraform state rm module.storage.azurerm_storage_account.sa-demo 

az resource move --destination-group rg-demo-project-b \
  --ids /subscriptions/your-subscription-id/resourceGroups/rg-demo-project-a/providers/Microsoft.Storage/storageAccounts/your-storage-account-name



# List resources of a specific type
az resource list --resource-type "Microsoft.Storage/storageAccounts" --output table

# Get the id of a specific resource
az resource show --resource-group rg-demo-project-b --name sademo12364s --resource-type "Microsoft.Storage/storageAccounts" --query id --output tsv


# Delete tfstate file from storage account
az storage blob delete --account-name sademobackendtim --container-name tfstate --name project_a.tfstate
az storage blob delete --account-name sademobackendtim --container-name tfstate --name project_b.tfstate