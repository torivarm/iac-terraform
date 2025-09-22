locals {
  # normalize suffix
  suffix = length(var.unique_suffix) > 0 ? lower(var.unique_suffix) : ""

  # composed names if not provided
  rg_name = var.resource_group_name != "" ? var.resource_group_name : (
    local.suffix != "" ? "rg-${var.name_prefix}-${local.suffix}" : "rg-${var.name_prefix}"
  )

  # SA must be 3–24, lowercase alphanum. Keep it short.
  sa_name = var.storage_account_name != "" ? var.storage_account_name : (
    local.suffix != "" ? "st${var.name_prefix}${local.suffix}" : "st${var.name_prefix}"
  )

  kv_name = var.kv_name != "" ? var.kv_name : (
    local.suffix != "" ? "kv-${var.name_prefix}-${local.suffix}" : "kv-${var.name_prefix}"
  )

  # Principals to grant roles to
  principals = toset(
    concat(
      var.extra_principal_ids,
      var.assign_current_user ? [data.azurerm_client_config.current.object_id] : []
    )
  )
}
