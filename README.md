<p align="center">
  <a href="https://jamfox.dev">
    <img alt="JF" src="https://raw.githubusercontent.com/JamFox/wired.jamfox.dev/main/src/android-chrome-192x192.png" width="60" />
  </a>
</p>
<h1 align="center">
JamLab Packer Builds
</h1>

Packer configurations for building homelab images.

Configuration with [Proxmox Builder (ISO)](https://www.packer.io/plugins/builders/proxmox/iso).

## Usage

(Optional) Set up API access to Proxmox if you do not wish to use cluster admin to execute tasks. Follow the [Telmate Proxmox Terraform Provider Docs](https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/index.md).

1. Set up sensitive PVE connection variables using `pve.hvl.sample` as a reference.
2. Build images with:
```bash
cd <DISTRO DIR>
PACKER_LOG=1 packer build -var-file <PATH TO PVE VAR FILE> <PACKER FILE>.pkr.hcl
```

Output is a VM template in PVE.

### Preseed

Preseed should be started over http from the `boot_command` in the packer configuration.

Preseeding provides a way to answer questions asked during the installation process without having to manually enter the answers while the installation is running. Read more about this method in the [preseed documentation](https://wiki.debian.org/DebianInstaller/Preseed).

### Cloud-init

Cloud-init is for post-installation configuration and should be enabled in packer configuration with the variable `cloud_init` set to true and then the cloud-config file copied using the file provisioner to `/etc/cloud/cloud.cfg`.

Cloud-init is used for initial machine configuration like creating users, installing packages, custom scripts or preseeding `authorized_keys` file for SSH authentication. Read more about this in [cloud-init documentation](https://cloudinit.readthedocs.io/en/latest/).
