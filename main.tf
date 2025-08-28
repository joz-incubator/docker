provider "google" {
  project = var.project_id
  region  = var.region
}

module "network" {
  source               = "./modules/network"
  project_id           = var.project_id
  region               = var.region
  secondary_range_name = var.secondary_range_name
}

module "vm1" {
  source             = "./modules/vm"
  name               = "docker-vm-1"
  network_name       = module.network.vpc_name
  subnet_name        = module.network.subnet_self_link
  zone               = var.zone
  startup_script     = file("scripts/startup_vm1.sh")
  alias_ip_range     = "192.168.100.0/24"
  alias_range_name   = var.secondary_range_name
}

module "vm2" {
  source             = "./modules/vm"
  name               = "docker-vm-2"
  network_name       = module.network.vpc_name
  subnet_name        = module.network.subnet_self_link
  zone               = var.zone
  startup_script     = file("scripts/startup_vm2.sh")
  alias_ip_range     = "192.168.200.0/24"
  alias_range_name   = var.secondary_range_name
}
