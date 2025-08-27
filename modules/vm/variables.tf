variable "name" {
  description = "Name of the VM instance"
  type        = string
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "zone" {
  description = "Zone where the VM will be deployed"
  type        = string
}

variable "startup_script" {
  description = "Startup script to configure the VM"
  type        = string
}
