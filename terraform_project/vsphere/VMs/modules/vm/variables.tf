variable "vm_name" {}
variable "resource_pool_id" {}
variable "datastore_id" {}
variable "num_cpus" { default = 2 }
variable "memory" { default = 2048 }

variable "template_guest_id" {}
variable "scsi_type" {}

variable "network_id" {}
variable "adapter_type" {}
variable "disk_label" {}
variable "disk_size" {}

variable "template_uuid" {}
variable "hostname" {}
variable "domain" {}
variable "ipv4_address" {}
variable "ipv4_netmask" {}
variable "ipv4_gateway" {}

variable "dns_server"{
   type    = list(any)
  default = []
}
variable "create_vm_base" {
  description = "Créer la VM base"
  type        = bool
  default     = true
}


//variable "cloud_init_file" {}
/*variable "depends_on_extra" {
  type    = list(any)
  default = []
}*/
