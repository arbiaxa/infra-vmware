variable "datacenter_name"{

   default = "flexos_dc"

}

variable "compute_cluster_name"{

   default = "flexos-compute-cluster"

}





variable "ESXI_host_name" {
    description = "Liste des adresses IP des hôtes ESXi à gérer"
   default     = "192.168.10.1" # Exemple avec 1 IP de serveur 
}


variable "ESXI_Hosts_IPLicense"{

 type        = map(string)
  default     = {
    "192.168.x.y" = "00000-00000-00000-00000-00000"
   # "esxi-02.example.com" = "license-key-02"
    #"esxi-03.example.com" = "license-key-03"
  }

}


variable "vss_name" {
  
    default= "switch-01"
}

variable "cluster_name"{


    default ="cluster_FLEXOS"
}

variable "vsphere_vmfs_datastore_name" {
  default= "datastore-01"
}

variable "windowsserver_name" {
  default= "windowsserver"
}

variable "vm_Edge_name"{
    default= "Edge_VM"
}
variable "vm_Interne_name"{
    default= "Intern_VM"
}


variable "create_vm_base" {
  description = "Créer la VM base"
  type        = bool
  default     = true
}












