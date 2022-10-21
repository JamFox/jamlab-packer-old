variable "iso_checksum" {
  type    = string
  default = "e307d0e583b4a8f7e5b436f8413d4707dd4242b70aea61eb08591dc0378522f3"
}

variable "iso_url" {
  type    = string
  default = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.5.0-amd64-netinst.iso"
}

variable "vm_name" {
  type    = string
  default = "debian-11.5.0-amd64"
}

variable "sockets" {
  type    = string
  default = "2"
}

variable "cores" {
  type    = string
  default = "2"
}

variable "disk_format" {
  type    = string
  default = "raw"
}

variable "disk_size" {
  type    = string
  default = "200G"
}

variable "cloudinit_storage_pool" {
  type    = string
  default = "local"
}

variable "disk_storage_pool" {
  type    = string
  default = "thpl"
}

variable "disk_storage_pool_type" {
  type    = string
  default = "lvm-thin"
}

variable "memory" {
  type    = string
  default = "31744"
}

variable "network_vlan" {
  type    = string
  default = ""
}

variable "proxmox_api_password" {
  type      = string
  sensitive = true
}

variable "proxmox_api_user" {
  type = string
}

variable "proxmox_host" {
  type = string
}

variable "proxmox_node" {
  type = string
}

source "proxmox-iso" "debian-11" {
  proxmox_url              = "https://${var.proxmox_host}/api2/json"
  insecure_skip_tls_verify = true
  username                 = var.proxmox_api_user
  password                 = var.proxmox_api_password

  template_description = "Debian 11 cloud-init template. Built on ${formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())}"
  node                 = var.proxmox_node
  network_adapters {
    bridge   = "vmbr0"
    firewall = true
    model    = "virtio"
    vlan_tag = var.network_vlan
  }
  disks {
    disk_size         = var.disk_size
    format            = var.disk_format
    io_thread         = true
    storage_pool      = var.disk_storage_pool
    storage_pool_type = var.disk_storage_pool_type
    type              = "scsi"
  }
  scsi_controller = "virtio-scsi-single"
  
  http_directory = "./"
  boot_wait      = "10s"
  boot_command   = ["<esc><wait>auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"]
  unmount_iso    = true

  iso_checksum            = var.iso_checksum
  iso_url                 = var.iso_url
  iso_storage_pool        = "local"
  cloud_init              = true
  cloud_init_storage_pool = var.cloudinit_storage_pool

  vm_name  = var.vm_name
  cpu_type = "host"
  os       = "l26"
  memory   = var.memory
  cores    = var.cores
  sockets  = var.sockets

  qemu_agent = true

  ssh_password = "packer"
  ssh_username = "root"
  ssh_timeout  = "20m"
}

build {
  sources = ["source.proxmox-iso.debian-11"]

  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg"
    source      = "cloud.cfg"
  }

  provisioner "shell" {
    inline = [
      "rm /etc/ssh/ssh_host_*",
      "rm /etc/machine-id /var/lib/dbus/machine-id",
      "touch /etc/machine-id && ln -s /etc/machine-id /var/lib/dbus/machine-id",
    ]
  }
  
  provisioner "shell" {
    script = "bootstrap.sh"
  }
}
