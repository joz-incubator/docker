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

