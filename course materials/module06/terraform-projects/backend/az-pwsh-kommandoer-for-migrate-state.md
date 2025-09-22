terraform init -migrate-state \
    -backend-config="../shared/backend.hcl" \
    -backend-config="key=projects/backend/terraform.tfstate"


terraform init -migrate-state `
    -backend-config="../shared/backend.hcl" `
    -backend-config="key=projects/backend/terraform.tfstate" 