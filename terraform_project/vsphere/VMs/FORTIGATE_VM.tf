
data "vsphere_ovf_vm_template" "ovfLocal" {
   depends_on = [
    vsphere_host_port_group.forti
    
  ]
  name              = "fortigate"
  disk_provisioning = "thin"
  resource_pool_id  = vsphere_resource_pool.resource_pool_fortigate.id
  datastore_id      = data.vsphere_datastore.datastore.id
  host_system_id    = data.vsphere_host.esxi_host.id
  local_ovf_path    = "/home/arbeya/terraform_project/vsphere/VMs/ovf_files/FortiGate-VM64.ovf"
 ovf_network_map = {
    "Network 1" = data.vsphere_network.wan_network.id
    "Network 2" = data.vsphere_network.dmz_network.id
    "Network 3" = data.vsphere_network.forti_network.id
  

  }
 
  
}

resource "vsphere_file" "config_iso_upload" {
  datacenter         = data.vsphere_datacenter.datacenter.name
  datastore          = data.vsphere_datastore.datastore.name
  source_file        = "/home/arbeya/terraform_project/vsphere/VMs/FG-iso/Day0-CFG-Drive.iso"
  destination_file   = "iso/Day0-CFG-Drive.iso"
  create_directories = true
}

resource "vsphere_file" "FG_internal_config_iso_upload" {
  datacenter         = data.vsphere_datacenter.datacenter.name
  datastore          = data.vsphere_datastore.datastore.name
  source_file        = "/home/arbeya/terraform_project/vsphere/VMs/FG-iso/Day0-CFG-Drive-internal.iso"
  destination_file   = "iso/Day0-CFG-Drive-internal.iso"
  create_directories = true
}

# Deployment of VM from Local OVF
resource "vsphere_virtual_machine" "FortigatevmFromLocalOvf" {
  name                 = "fortigate"
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  host_system_id       = data.vsphere_host.esxi_host.id
  resource_pool_id     = vsphere_resource_pool.resource_pool_fortigate.id
  num_cpus             = data.vsphere_ovf_vm_template.ovfLocal.num_cpus
  num_cores_per_socket = data.vsphere_ovf_vm_template.ovfLocal.num_cores_per_socket
  memory               = data.vsphere_ovf_vm_template.ovfLocal.memory
  guest_id             = data.vsphere_ovf_vm_template.ovfLocal.guest_id
  firmware             = "bios"
  scsi_type            = data.vsphere_ovf_vm_template.ovfLocal.scsi_type

dynamic "network_interface" {
  for_each = data.vsphere_ovf_vm_template.ovfLocal.ovf_network_map
  content {
    network_id = network_interface.value
    adapter_type = "vmxnet3"
  }
}

  # Wait conf
  wait_for_guest_ip_timeout  = 0
  wait_for_guest_net_timeout = 0
  # Boot Conf
  boot_delay         = 0
  boot_retry_enabled = false
  
  ovf_deploy {
    allow_unverified_ssl_cert = false
    local_ovf_path            = data.vsphere_ovf_vm_template.ovfLocal.local_ovf_path
    disk_provisioning         = data.vsphere_ovf_vm_template.ovfLocal.disk_provisioning
    ovf_network_map           = data.vsphere_ovf_vm_template.ovfLocal.ovf_network_map
  }

  cdrom {
   # client_device = true
    datastore_id = data.vsphere_datastore.datastore.id
    path         = "iso/Day0-CFG-Drive.iso"

 
  }
depends_on = [
    vsphere_file.config_iso_upload,
     vsphere_host_port_group.forti
    
  ]


  
}

data "vsphere_ovf_vm_template" "ovfLocal-Interne" {
  name              = "fortigate"
  disk_provisioning = "thin"
  resource_pool_id  = vsphere_resource_pool.resource_pool_fortigate.id
  datastore_id      = data.vsphere_datastore.datastore.id
  host_system_id    = data.vsphere_host.esxi_host.id
  local_ovf_path    = "/home/arbeya/terraform_project/vsphere/VMs/ovf_files/FortiGate-VM64.ovf"
 ovf_network_map = {
    "Network 1" = data.vsphere_network.lan_network.id
    "Network 2" = data.vsphere_network.forti_network.id
    "Network 3" = data.vsphere_network.dmz_network.id

  }
}

resource "vsphere_virtual_machine" "FortigatevmFromLocalOvf-in" {
  name                 = "In-fortigate"
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  host_system_id       = data.vsphere_host.esxi_host.id
  resource_pool_id     = vsphere_resource_pool.resource_pool_fortigate.id
  num_cpus             = data.vsphere_ovf_vm_template.ovfLocal-Interne.num_cpus
  num_cores_per_socket = data.vsphere_ovf_vm_template.ovfLocal-Interne.num_cores_per_socket
  memory               = data.vsphere_ovf_vm_template.ovfLocal-Interne.memory
  guest_id             = data.vsphere_ovf_vm_template.ovfLocal-Interne.guest_id
 firmware             = "bios"
  scsi_type            = data.vsphere_ovf_vm_template.ovfLocal-Interne.scsi_type

dynamic "network_interface" {
  for_each = data.vsphere_ovf_vm_template.ovfLocal-Interne.ovf_network_map
  content {
    network_id = network_interface.value
    adapter_type = "vmxnet3"
  }
}


  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  # Boot Configuration
  boot_delay         = 300000 #wait for  5min
  boot_retry_enabled = false


  ovf_deploy {
    allow_unverified_ssl_cert = false
    local_ovf_path            = data.vsphere_ovf_vm_template.ovfLocal-Interne.local_ovf_path
    disk_provisioning         = data.vsphere_ovf_vm_template.ovfLocal-Interne.disk_provisioning
    ovf_network_map           = data.vsphere_ovf_vm_template.ovfLocal-Interne.ovf_network_map
  }

  cdrom {
  #attach iso file 
    datastore_id = data.vsphere_datastore.datastore.id
    path         = "iso/Day0-CFG-Drive-internal.iso"


  }


 depends_on = [
    vsphere_file.FG_internal_config_iso_upload,
    vsphere_virtual_machine.FortigatevmFromLocalOvf,
  
  ]
  
}

 #-------------------------------deploy fortiweb VM--------------------------------------------------
data "vsphere_virtual_machine" "fortiweb-template" {
  name          = "fortiweb-templ"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "Fortiweb" {
  name                 = "fortiweb-vm"
  datastore_id         = data.vsphere_datastore.datastore.id
  host_system_id       = data.vsphere_host.esxi_host.id
  resource_pool_id     = vsphere_resource_pool.resource_pool_fortigate.id
  num_cpus             = data.vsphere_virtual_machine.fortiweb-template.num_cpus
  num_cores_per_socket = data.vsphere_virtual_machine.fortiweb-template.num_cores_per_socket
  memory               = data.vsphere_virtual_machine.fortiweb-template.memory
  guest_id             = data.vsphere_virtual_machine.fortiweb-template.guest_id
  firmware             = "bios"
  scsi_type            = data.vsphere_virtual_machine.fortiweb-template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.dmz_network.id
    adapter_type =  "vmxnet3"
 
  }
  network_interface {
    network_id   = data.vsphere_network.dmz_network.id
   adapter_type =  data.vsphere_virtual_machine.fortiweb-template.network_interface_types[0]
  }
  disk {
    label             = "fortiweb-disk"
    size              = data.vsphere_virtual_machine.fortiweb-template.disks[0].size
    thin_provisioned  = true
  }
  cdrom {
  client_device = true
}
 #config waiters
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

   clone {
    template_uuid = data.vsphere_virtual_machine.fortiweb-template.id
    timeout = 120
  
  }
  
}









