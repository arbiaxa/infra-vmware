data "vsphere_host_thumbprint" "thumbprint" {
  address  = "172.16.10.250"
  insecure = true  // as a best practise in prod invironmnt is to set it manually
}



data "vsphere_datacenter" "datacenter" {
  name = "Datacenter_flexos"
}



data "vsphere_compute_cluster" "compute_cluster" {
  name            = "Cluster_flexos"
  datacenter_id   = data.vsphere_datacenter.datacenter.id

 
}


data "vsphere_host" "esxi_host" {
  name          = "172.16.10.253"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_datastore" "datastore" {
  name          = "datastore1"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}




data "vsphere_network" "lan_network" {
  name          = vsphere_host_port_group.lan.name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_network" "dmz_network" {
  name          = vsphere_host_port_group.dmz.name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
//vsphere_network.wan_network.id

data "vsphere_network" "wan_network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}




data "vsphere_network" "forti_network" {
  name          = vsphere_host_port_group.forti.name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


/*data "vsphere_virtual_machine" "template_ubuntu" {
  name          = "linux-template"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
*/
data "vsphere_virtual_machine" "template_ubuntu" {
   // depends_on     = [null_resource.wait_for_fortigate_ip]
  name          = "ubuntu-base"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

