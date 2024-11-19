#!/bin/bash

RESOURCE_GROUP="timlab-dev-rg"
WEBAPP_NAME="timlab-dev-webapp"

# Get all app settings in table format
echo "Current App Settings:"
az webapp config appsettings list \
    --name $WEBAPP_NAME \
    --resource-group $RESOURCE_GROUP \
    --output table

# Get all app settings in TSV format for easy copying
echo -e "\nSettings in key = value format:"
az webapp config appsettings list \
    --name $WEBAPP_NAME \
    --resource-group $RESOURCE_GROUP \
    --output tsv \
    --query "[].{name:name, value:value}" | \
while IFS=$'\t' read -r name value; do
    echo "    \"$name\" = \"$value\""
done