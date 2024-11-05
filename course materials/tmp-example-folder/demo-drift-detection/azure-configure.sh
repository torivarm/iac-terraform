#!/bin/bash

RESOURCE_GROUP="timlab-dev-rg"
APP_SERVICE_PLAN="timlab-dev-asp"
WEBAPP_NAME="timlab-dev-webapp"
STORAGE_ACCOUNT="timlabfozvkbep"

# Scale up App Service Plan (can be changed without replacement)
az appservice plan update \
    --name $APP_SERVICE_PLAN \
    --resource-group $RESOURCE_GROUP \
    --sku P1v2 > /dev/null 2>&1

# Modify storage account configurations that don't require replacement
az storage account update \
    --name $STORAGE_ACCOUNT \
    --resource-group $RESOURCE_GROUP \
    --enable-large-file-share \
    --allow-blob-public-access false \
    --min-tls-version TLS1_2 > /dev/null 2>&1

# Update tags (can be changed without replacement)
az storage account update \
    --name $STORAGE_ACCOUNT \
    --resource-group $RESOURCE_GROUP \
    --tags environment=production owner=emergency-response cost-center=ops-123 > /dev/null 2>&1

# Add new application settings
az webapp config appsettings set \
    --name $WEBAPP_NAME \
    --resource-group $RESOURCE_GROUP \
    --settings \
    CACHE_ENABLED="true" \
    MAX_WORKERS="4" \
    OPTIMIZATION_LEVEL="aggressive" > /dev/null 2>&1

# Update Web App configurations
az webapp config set \
    --name $WEBAPP_NAME \
    --resource-group $RESOURCE_GROUP \
    --number-of-workers 4 \
    --always-on true > /dev/null 2>&1