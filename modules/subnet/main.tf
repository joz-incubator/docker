
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.name}-subnet"
  ip_cidr_range = var.cidr
  region        = var.region
  network = var.network_self_link

  secondary_ip_range {
    range_name    = var.dock_range_name
    ip_cidr_range = var.cidrdock
  }
}


resource "google_compute_router" "router" {
  name    = "${var.name}-router"
  network = var.network_self_link
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.name}-nat"
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

output "subnet_name" {
  value = google_compute_subnetwork.subnet.name
}
