locals {
  common_tags = merge(var.tags, {
    environment = var.environment
    managed_by  = "terraform"
  })
  
  name_prefix = "rg-${var.environment}"
}