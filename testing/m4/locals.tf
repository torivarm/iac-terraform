locals {
  # Ett felles navnemønster som alle ressursnavn bygges fra
  name_prefix = "${var.student_id}-${var.project}"

  common_tags = {
    owner  = var.student_id
    course = "iac"
    module = "modul4"
    # ManagedBy forteller den som finner ressursen i portalen at den ikke skal
    # endres for hånd – endringer gjøres i koden, ellers oppstår drift.
    managed_by = "terraform"
  }

}
