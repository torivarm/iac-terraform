variable "subscription_id" {
  description = "Azure subscription to deploy into. If omitted, provider will use CLI default subscription."
  type        = string
  default     = null
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
}

variable "name_prefix" {
  description = "Short prefix for naming (e.g. course or class code). Lowercase letters and digits only."
  type        = string
}

variable "unique_suffix" {
  description = "Unique, short suffix to ensure global-unique names (letters/digits). Leave empty to auto-generate."
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "Optional explicit RG name. If empty, a name is composed from prefix and suffix."
  type        = string
  default     = ""
}

variable "storage_account_name" {
  description = "Optional explicit Storage Account name (must be globally unique, 3-24 lowercase alphanum). If empty, composed automatically."
  type        = string
  default     = ""
}

variable "container_name" {
  description = "Blob container name for Terraform state."
  type        = string
  default     = "tfstate"
}

variable "kv_name" {
  description = "Optional explicit Key Vault name (global within Azure). If empty, composed automatically."
  type        = string
  default     = ""
}

variable "kv_sku_name" {
  description = "Key Vault SKU."
  type        = string
  default     = "standard"
}

variable "assign_current_user" {
  description = "Whether to assign RBAC roles to the currently logged-in user."
  type        = bool
  default     = true
}

variable "extra_principal_ids" {
  description = "Optional list of AAD object IDs (e.g. App Registrations / Service Principals) to grant RBAC on SA container and Key Vault."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common tags for all resources."
  type        = map(string)
  default = {
    purpose   = "tf-backend"
    lifecycle = "platform"
    cleanup   = "exclude"
  }
}
