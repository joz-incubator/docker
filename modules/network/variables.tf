variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "secondary_range_name" {
  description = "Name of the secondary IP range used for alias IPs"
  type        = string
}
