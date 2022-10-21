<p align="center">
  <a href="https://jamfox.dev">
    <img alt="JF" src="https://raw.githubusercontent.com/JamFox/JamFox/main/images/icon.png" width="60" />
  </a>
</p>
<h1 align="center">
JamLab Packer Builds
</h1>

Packer configurations for building homelab images.

Configuration with [Proxmox Builder (ISO)](https://www.packer.io/plugins/builders/proxmox/iso).

## Usage

1. Set up sensitive PVE connection variables using `pve.hvl.sample` as a reference.
2. Build images with:
```bash
cd <DISTRO DIR>
PACKER_LOG=1 packer build -var-file <PATH TO PVE VAR FILE> <PACKER FILE>.pkr.hcl
```

Output is a VM template in PVE.
