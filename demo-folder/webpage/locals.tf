locals {
    resource_group_name = "${var.nameprefix}-${var.project}-${var.environment}-rg"
    
    tags = {
        owner       = var.owner
        costcenter  = var.costcenter
        project     = var.project
        environment = var.environment
        }
    
}