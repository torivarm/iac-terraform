# Set the root folder name
$rootFolderName = "TerraformProject"

# Create the root folder
New-Item -Path $rootFolderName -ItemType Directory

# Create root level files
$rootFiles = @("main.tf", "variables.tf", "outputs.tf", "terraform.tfvars", "commands.sh", "imports.tf")
foreach ($file in $rootFiles) {
    New-Item -Path "$rootFolderName\$file" -ItemType File
}

# Create modules folder
New-Item -Path "$rootFolderName\modules" -ItemType Directory

# Define module folder names
$moduleFolders = @("storage", "network")

# Create module folders and their files
foreach ($folder in $moduleFolders) {
    $folderPath = "$rootFolderName\modules\$folder"
    New-Item -Path $folderPath -ItemType Directory
    
    $moduleFiles = @("main.tf", "variables.tf", "outputs.tf")
    foreach ($file in $moduleFiles) {
        New-Item -Path "$folderPath\$file" -ItemType File
    }
}

# Add content to the root main.tf file
$mainTfContent = @"
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
}

provider "azurerm" {
  subscription_id = "5513747a-818d-4f48-83b0-da2b2fd4cb97"
  features {

  }
}
"@

Set-Content -Path "$rootFolderName\main.tf" -Value $mainTfContent

Write-Host "Terraform project structure created successfully!"