resource "google_compute_network" "vpcdocker" {
  name                    = "docker-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "iap_ssh" {
  name    = "docker-iap"
  network = google_compute_network.vpcdocker.self_link
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap-ssh"]
}

resource "google_compute_firewall" "egress443" {
  name    = "docker-egress443"
  network = google_compute_network.vpcdocker.self_link
  direction = "EGRESS"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  destination_ranges = ["0.0.0.0/0"]
}


resource "google_compute_router" "router" {
  name    = "docker-router"
  network = google_compute_network.vpcdocker.self_link
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  name                               = "docker-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  enable_endpoint_independent_mapping = true

  min_ports_per_vm = 64

  log_config {
    enable = true
    filter = "ALL"
  }
}

resource "google_compute_subnetwork" "subnet" {
  name          = "docker-subnet"
  ip_cidr_range = "10.0.10.0/24"
  region        = var.region
  network = google_compute_network.vpcdocker.self_link

  secondary_ip_range {
    range_name    = "docker-ipvlan"
    ip_cidr_range = "192.168.0.0/16"
  }
}
