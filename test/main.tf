resource "proxmox_vm_qemu" "proxmox_vm_master" {
  count = var.master_count
  name  = "cluster-master-${count.index}"
  desc  = "Cluster Master Node"
  ipconfig0   = "gw=${var.k3s_gateway},ip=${var.k3s_master_ip_addresses[count.index]}"
  target_node = var.k3s_master_pve_node[count.index]
  onboot      = true
  hastate     = "started"
  # Same CPU as the Physical host, possible to add cpu flags
  # Ex: "host,flags=+md-clear;+pcid;+spec-ctrl;+ssbd;+pdpe1gb"
  cpu        = "host"
  numa       = false
  clone      = "${var.template_vm_name}-${var.k3s_master_pve_node[count.index]}"
  os_type    = "cloud-init"
  agent      = 1
  ciuser     = var.k3s_user
  memory     = var.num_k3s_master_mem
  cores      = var.k3s_master_cores
  nameserver = var.k3s_nameserver
 
  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = var.k3s_vlan
  }

  serial {
    id   = 0
    type = "socket"
  }

  vga {
    type = "serial0"
  }

  disk {
    size    = var.k3s_master_root_disk_size
    storage = var.k3s_master_disk_storage
    type    = "scsi"
    format  = "qcow2"
    backup  = 1
  }

  disk {
    size    = var.k3s_master_data_disk_size
    storage = var.k3s_master_disk_storage
    type    = "scsi"
    format  = "qcow2"
    backup  = 1
  }

  lifecycle {
    ignore_changes = [
      network, disk, sshkeys, target_node
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_workers" {
  count = var.worker_count
  name  = "k3s-worker-${count.index}"
  ipconfig0   = "gw=${var.k3s_gateway},ip=${var.k3s_worker_ip_addresses[count.index]}"
  target_node = var.k3s_worker_pve_node[count.index]
  onboot      = true
  hastate     = "started"
  # Same CPU as the Physical host, possible to add cpu flags
  # Ex: "host,flags=+md-clear;+pcid;+spec-ctrl;+ssbd;+pdpe1gb"
  cpu   = "host"
  numa  = false
  clone = "${var.template_vm_name}-${var.k3s_worker_pve_node[count.index]}"
  os_type    = "cloud-init"
  agent      = 1
  ciuser     = var.k3s_user
  memory     = var.num_k3s_node_mem
  cores      = var.k3s_node_cores
  nameserver = var.k3s_nameserver

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = var.k3s_vlan
  }

  serial {
    id   = 0
    type = "socket"
  }

  vga {
    type = "serial0"
  }

  disk {
    size    = var.k3s_node_root_disk_size
    storage = var.k3s_node_disk_storage
    type    = "scsi"
    format  = "qcow2"
    backup  = 1
  }

  disk {
    size    = var.k3s_node_data_disk_size
    storage = var.k3s_node_disk_storage
    type    = "scsi"
    format  = "qcow2"
    backup  = 1
  }

  lifecycle {
    ignore_changes = [
      network, disk, sshkeys, target_node
    ]
  }
}

# Ansible web hosts
resource "ansible_host" "web" {
  count  = lookup(var.role_count, "web", 0)
  name   = "${var.region}-web-${count.index}"
  groups = ["osl_web"] # Groups this host is part of

  variables = {
    ansible_host = trim(openstack_compute_instance_v2.web_instance[count.index].access_ip_v6, "[]")
  }
}

# Ansible web group
resource "ansible_group" "web_group" {
  name     = "web"
  children = ["osl_web"]
  variables = {
    ansible_user = "almalinux"
  }
}
