<p align="center">
  <a href="https://jamfox.dev">
    <img alt="JF" src="https://raw.githubusercontent.com/JamFox/JamFox/main/images/icon.png" width="60" />
  </a>
</p>
<h1 align="center">
JamLab Packer Builds
</h1>

Packer configurations for building homelab images.

## Usage

Build images with:

`PACKER_LOG=1 packer build <PACKER FILE>.pkr.hcl`

Output saved to new directory called `artifacts/`.

## Structure

Each distro should be in it's own directory. Sample distro's directory structure:

```
debian11/              # Directory for Debian 11 distro
    http/              # Automated installation files (kickstart, preseed, etc) go here
    ansible/           # Ansible provisioner playbooks go here
    scripts/           # Shell provisioner scripts go here
    debian11.pkr.hcl   # Packer configuration. Name should match parent directory for convenient CI
```
