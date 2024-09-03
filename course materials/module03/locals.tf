locals {
  common_tags = {
    company      = var.company
    project      = "${var.company}-${var.project}"
    billing_code = var.billing_code
  }
}

locals {
  backend-net-rg     = "${var.company}-${var.project}-backend-net-rg"
  backend-net-vnet   = "${var.company}-${var.project}-backend-net-vnet"
  backend-net-subnet = "${var.company}-${var.project}-backend-net-subnet"
}