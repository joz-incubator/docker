
provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "vpcdocker" {
  name                    = "main-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "iap_ssh" {
  name    = "iap-ssh-vpc"
  network_self_link = google_compute_network.vpcdocker.self_link
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap-ssh"]
}

resource "google_compute_firewall" "egress443" {
  name    = "egress-443-vpc"
  network_self_link = google_compute_network.vpcdocker.self_link
  direction = "EGRESS"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  destination_ranges = ["0.0.0.0/0"]
}

module "subnet1" {
  source = "./modules/subnet"
  name = "subnet1"
  network_self_link = google_compute_network.vpcdocker.self_link
  cidr   = "10.0.10.0/24"
  cidrdock   = "192.168.100.0/24"
  region = var.region
  dock_range_name = "docker-ipvlan1"
}

module "subnet2" {
  source = "./modules/subnet"
  name = "subnet2"
  network_self_link = google_compute_network.vpcdocker.self_link
  cidr   = "10.0.20.0/24"
  cidrdock   = "192.168.200.0/24"
  region = var.region
  dock_range_name = "docker-ipvlan2"
}

module "vm1" {
  source         = "./modules/vm"
  name           = "vm-1"
  network_name = google_compute_network.vpcdocker.name
  subnet_name  = module.subnet1.subnet_name
  zone           = var.zone
  startup_script = file("scripts/startup_vm1.sh")
  alias_ip_range      = "192.168.100.0/24"
  alias_range_name    = "docker-ipvlan1"
}

module "vm2" {
  source         = "./modules/vm"
  name           = "vm-2"
  network_name = google_compute_network.vpcdocker.name
  subnet_name  = module.subnet2.subnet_name
  zone           = var.zone
  startup_script = file("scripts/startup_vm2.sh")
  alias_ip_range      = "192.168.200.0/24"
  alias_range_name    = "docker-ipvlan2"
}

