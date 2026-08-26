module "network" {
  source         = "../modules/network"
  rg_name        = var.rg_name
  location       = var.location
  environment    = var.environment
  name_prefix    = var.name_prefix
  vnet_cidr      = var.vnet_cidr
  subnet_cidr    = var.subnet_cidr
  allow_ssh_cidr = var.allow_ssh_cidr
  tags           = var.tags
}

module "compute" {
  source             = "../modules/compute-vm"
  rg_name            = var.rg_name
  location           = var.location
  environment        = var.environment
  name_prefix        = var.name_prefix
  subnet_id          = module.network.subnet_id
  vm_size            = var.vm_size
  admin_username     = var.admin_username
  ssh_public_key     = var.ssh_public_key
  allocate_public_ip = var.allocate_public_ip
  tags               = var.tags
}
