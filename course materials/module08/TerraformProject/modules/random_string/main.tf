resource "random_string" "random_string" {
  length  = var.length
  special = var.special
  upper   = var.upper
}
