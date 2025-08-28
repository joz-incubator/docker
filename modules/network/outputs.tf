output "vpc_name" {
  value = google_compute_network.vpcdocker.name
}

output "subnet_self_link" {
  value = google_compute_subnetwork.subnet.self_link
}
