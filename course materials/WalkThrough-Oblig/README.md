# Terraform Azure – RG i environments (dev/test/prod)

Struktur:
- `modules/` – gjenbrukbare moduler (nettverk, VM).
- `stacks/` – komposisjon av moduler til en deploybar stack (uten RG).
- `environments/{dev,test,prod}` – **root modules** som eier Resource Group, backend, provider og kaller stacken.

## Første gangs kjøring (eksempel: dev)
```bash
cd environments/dev

terraform init \
  -backend-config="resource_group_name=<RG_FOR_TFSTATE>" \
  -backend-config="storage_account_name=<STORAGE_ACCOUNT>" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=demo/dev.tfstate"

terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
