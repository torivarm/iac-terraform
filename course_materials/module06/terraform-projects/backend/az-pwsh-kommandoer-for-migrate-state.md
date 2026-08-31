# Bash
terraform init -migrate-state \
    -backend-config="../shared/backend.hcl" \
    -backend-config="key=projects/backend/terraform.tfstate"
# "key=<Folder(s) en ønsker å opprette i Container>/filnavn.tfstate

# PowerShell
terraform init -migrate-state `
    -backend-config="../shared/backend.hcl" `
    -backend-config="key=projects/backend/terraform.tfstate" 