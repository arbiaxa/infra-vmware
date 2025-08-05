




//Creation de resource pool in existing cluster
resource "vsphere_resource_pool" "resource_pool_lan" {
  name                    = "lan-resource-pool"
  cpu_share_level = "custom"
  cpu_shares = 2000 #high
  memory_shares = 2000
  parent_resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
}
//Creation de resource pool in existing cluster
resource "vsphere_resource_pool" "resource_pool_dmz" {
  name                    = "dmz-resource-pool"
  cpu_share_level = "custom"
  cpu_shares = 2000 #high
  memory_shares = 2000
  parent_resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
}


//Creation de resource pool in existing cluster
resource "vsphere_resource_pool" "resource_pool_fortigate" {
  name                    = "fortigates-resource-pool"
  cpu_limit = 3000  // en Mhz
  cpu_reservation =  2400 // en Mhz  yaani un core physique pour 2vcpu
  cpu_share_level = "custom"
  cpu_shares = 4000 #high

  memory_reservation = 4128
  memory_limit = 6144 //6GB
  memory_shares = 4000
  parent_resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
  #parent_resource_pool_id = data.vsphere_host.host.resource_pool_id
}