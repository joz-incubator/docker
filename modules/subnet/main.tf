
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

output "subnet_name" {
  value = google_compute_subnetwork.subnet.name
}
