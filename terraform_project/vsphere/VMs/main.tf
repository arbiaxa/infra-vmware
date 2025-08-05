terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.9.3"
    }

   vault = {
      source = "hashicorp/vault"
      version = "4.7.0"
    }

  }
}



provider "vsphere" {
 # user                 = data.vault_kv_secret_v2.vCenter_credentials.data["username"]
 # password             = data.vault_kv_secret_v2.vCenter_credentials.data["password"]


 user = "administrator@vsphere.local"
 password = "Flexos123."
  vsphere_server       = "172.16.10.250"
  allow_unverified_ssl  = true
  api_timeout          = 10
}


provider "vault" {
  address = "https://192.168.80.131:8200"   #adresse de vault server
  # skip_child_token = true a
  ca_cert_file = "./certif"
  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id =  "40fce769-84d1-092e-c651-38030ba5a16c"
      secret_id = "64c0d7fb-4c4f-e205-91b6-9a16e4794ab2"

    }
  }
 
}




/*data "vault_kv_secret_v2" "keyvalue" {
  mount = "kv" // name of path 
  name  = "test-secret" // cname of secret
}

data "vault_kv_secret_v2" "vCenter_credentials" {
  mount = "credentials" // name of path 
  name  = "vCenter_credential" // cname of secret
}*/



/*resource "local_file" "example" {
  # Le contenu du fichier
  content = data.vault_kv_secret_v2.keyvalue.data["userr"]

  # Chemin du fichier à créer sur ton disque
  filename = "C:/terraform_project/example.txt"
}*/









#step 1 : create a data center

/*resource "vsphere_datacenter" "flexos_dc" {
  name = var.datacenter_name
}
*/

#step2:
/*resource "vsphere_compute_cluster" "compute_cluster" {
  name            = var.cluster_name
  datacenter_id   = vsphere_datacenter.flexos_dc.id
  #host_system_ids = vsphere_host.ESXi-01.id

 # drs_enabled          = true
  #drs_automation_level = "fullyAutomated"

  #ha_enabled = true
}
*/
#step 2 :add  esxi host

/*resource "vsphere_host" "ESXi-01" {
  hostname   = var.ESXI_host_name
  username   =   data.vault_kv_secret_v2.keyvalue.data["username_esxihost"]
  password   =  data.vault_kv_secret_v2.keyvalue.data["password_esxihost"]
  license    = "00000-00000-00000-00000-00000" #this is the license of esxi host
  thumbprint = data.vsphere_host_thumbprint.thumbprint
  cluster    = data.vsphere_compute_cluster.cluster.id

}*/



#Creation de port Groups
resource "vsphere_host_port_group" "dmz" {
  name                = "PG_DMZ"
  host_system_id      = data.vsphere_host.esxi_host.id 
  virtual_switch_name = "vSwitch0"  //nom de virtual switch

  vlan_id = 200

  allow_promiscuous = true
}

resource "vsphere_host_port_group" "lan" {
  name                = "PG_LAN"
  host_system_id      = data.vsphere_host.esxi_host.id 
  virtual_switch_name = "vSwitch0"

  vlan_id = 100

  allow_promiscuous = true
}




resource "vsphere_host_port_group" "forti" {
  name                = "PG_FORTI"
  host_system_id      = data.vsphere_host.esxi_host.id 
  virtual_switch_name = "vSwitch0"

  vlan_id = 300  

  allow_promiscuous = true
}




module "vm_dmz_master" {
  depends_on = [
    vsphere_host_port_group.dmz,
  ]
  source = "./modules/vm"

  vm_name          = "k8s-master"
  resource_pool_id = vsphere_resource_pool.resource_pool_dmz.id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = 2
  memory           = 2048

  template_guest_id  = data.vsphere_virtual_machine.template_ubuntu.guest_id
  scsi_type          = data.vsphere_virtual_machine.template_ubuntu.scsi_type
  network_id         = data.vsphere_network.dmz_network.id
  adapter_type       = "vmxnet3"
  disk_label         = "disk-vm-master"
  disk_size          = "30"
  template_uuid      = data.vsphere_virtual_machine.template_ubuntu.id

  hostname        = "vm-master"
  domain          = "flexos.tn"
  ipv4_address    = "192.168.90.10"
  ipv4_netmask    = 24
  ipv4_gateway    = "192.168.90.9"
  dns_server = ["8.8.8.8"]

   
}




module "vm_dmz_worker" {
  source = "./modules/vm"

  vm_name          = "k8s-worker"
  resource_pool_id = vsphere_resource_pool.resource_pool_dmz.id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = 2
  
  memory           = 2048

  template_guest_id  = data.vsphere_virtual_machine.template_ubuntu.guest_id
  scsi_type          = data.vsphere_virtual_machine.template_ubuntu.scsi_type
  network_id         = data.vsphere_network.dmz_network.id
  adapter_type       = "vmxnet3"
  disk_label         = "disk-vm-worker"
  disk_size          = 35
  template_uuid      = data.vsphere_virtual_machine.template_ubuntu.id

  hostname        = "vm-worker"
  domain          = "flexos.tn"
  ipv4_address    = "192.168.90.11"
  ipv4_netmask    = 24
  ipv4_gateway    = "192.168.90.9"
  dns_server = ["8.8.8.8"]

   depends_on = [
    vsphere_host_port_group.dmz,
  
  ]
}
      
