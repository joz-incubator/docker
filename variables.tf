variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "he-prod-itinfra-incubator"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west6" # Zurich region
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "europe-west6-a"
}
