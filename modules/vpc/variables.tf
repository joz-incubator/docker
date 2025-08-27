variable "name" {
  description = "Name of the VPC"
  type        = string
  default     = "vpc-xxx"
}

variable "cidr" {
  description = "CIDR range for the subnet"
  type        = string
  default     = "192.168.1.0/24"
}

variable "region" {
  description = "Region for the subnet and router"
  type        = string
  default     = "europe-west6"
}
