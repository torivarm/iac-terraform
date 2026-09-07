locals {
  # Ett felles navnemønster som alle ressursnavn bygges fra
  name_prefix = "${var.student_id}-${var.project}"

  resource_group_name = "${local.name_prefix}-rg"
}
