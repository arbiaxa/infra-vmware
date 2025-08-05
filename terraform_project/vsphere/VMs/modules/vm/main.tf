resource "vsphere_virtual_machine" "ubuntu-vm" {
  

   name             = var.vm_name
   resource_pool_id = var.resource_pool_id
   datastore_id     = var.datastore_id
   num_cpus         = var.num_cpus
   memory           = var.memory
   guest_id         = var.template_guest_id
   scsi_type        = var.scsi_type

 network_interface {
    network_id   = var.network_id
    adapter_type = var.adapter_type
  }

  disk {
    label             = var.disk_label
    size              = var.disk_size
    thin_provisioned  = true
  }
  cdrom {
  client_device = true
}
  
  wait_for_guest_net_timeout = 20
  wait_for_guest_ip_timeout  = 20

depends_on = []
   clone {
    template_uuid = var.template_uuid
    customize {
      linux_options {
        host_name = var.hostname
        domain    = var.domain
      }
      network_interface {
        ipv4_address = var.ipv4_address
        ipv4_netmask = var.ipv4_netmask
      }
      ipv4_gateway = var.ipv4_gateway
      dns_server_list = var.dns_server
       //timeout  = 5

    }
  }

  

  



 
}

