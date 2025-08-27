
provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "vpcdocker" {
  name                    = var.name
  auto_create_subnetworks = false
}


module "subnet1" {
  source = "./modules/vpc"
  name   = "vpc-1"
  cidr   = "10.0.10.0/24"
  cidrdock   = "192.168.100.0/24"
  iap_firewall_name     = "iap-ssh-vpc1"
  egress_firewall_name  = "egress-443-vpc1"
  region = var.region
  dock_range_name = "docker-ipvlan1"
}

module "subnet2" {
  source = "./modules/vpc"
  name   = "vpc-2"
  cidr   = "10.0.20.0/24"
  cidrdock   = "192.168.200.0/24"
  iap_firewall_name     = "iap-ssh-vpc2"
  egress_firewall_name  = "egress-443-vpc2"
  region = var.region
  dock_range_name = "docker-ipvlan2"
}

module "vm1" {
  source         = "./modules/vm"
  name           = "vm-1"
  network_name   = module.vpc1.network_name
  subnet_name    = module.vpc1.subnet_name
  zone           = var.zone
  startup_script = file("scripts/startup_vm1.sh")
  alias_ip_range      = "192.168.100.0/24"
  alias_range_name    = "docker-ipvlan1"
}

module "vm2" {
  source         = "./modules/vm"
  name           = "vm-2"
  network_name   = module.vpc2.network_name
  subnet_name    = module.vpc2.subnet_name
  zone           = var.zone
  startup_script = file("scripts/startup_vm2.sh")
  alias_ip_range      = "192.168.200.0/24"
  alias_range_name    = "docker-ipvlan2"
}

