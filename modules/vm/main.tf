
resource "google_compute_instance" "vm" {
  name         = var.name
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

    shielded_instance_config {
      enable_integrity_monitoring = true
      enable_secure_boot          = true
      enable_vtpm                 = true
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.subnet_name
 #   access_config {}

    alias_ip_range {
      ip_cidr_range         = var.alias_ip_range
      subnetwork_range_name = var.alias_range_name
    }

  }

  metadata_startup_script = var.startup_script

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["iap-ssh"]
}

resource "google_compute_firewall" "iap_ssh" {
  name    = var.iap_firewall_name
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap-ssh"]
}

resource "google_compute_firewall" "egress443" {
  name    = var.egress_firewall_name
  network = var.network_name

  direction = "EGRESS"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  destination_ranges = ["0.0.0.0/0"]
}
