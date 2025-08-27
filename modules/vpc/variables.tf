variable "name" {
  description = "Name of the VPC"
  type        = string
}

variable "cidr" {
  description = "CIDR range for the subnet"
  type        = string
}

variable "region" {
  description = "Region for the subnet and router"
  type        = string
}

variable "cidrdock" {
  description = "docker ip range"
  type = string
}

variable "dock_range_name" {
  type = string
}

variable "iap_firewall_name" {
  description = "Name of the IAP SSH firewall rule"
  type        = string
}

variable "egress_firewall_name" {
  description = "Name of the egress 443 firewall rule"
  type        = string
}
