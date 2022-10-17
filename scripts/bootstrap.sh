mkdir -p /etc/systemd/scripts

cat << SCRIPT_EOF > /etc/systemd/scripts/jamlab-firstboot
#!/bin/bash

# Set output
set -x
exec &> /var/log/jamlab_install.log

# Clone jamlab-ansible and bootstrap
ANSIBLE_REPO_URL=https://github.com/JamFox/jamlab-ansible.git
ANSIBLE_MAIN_DIR=/opt/jamlab-ansible
git clone $ANSIBLE_REPO_URL $ANSIBLE_MAIN_DIR
if [ $? -ne 0 ]; then
    echo -e "[ Unable to clone $ANSIBLE_REPO_URL" >&2
    exit 1
fi

$ANSIBLE_MAIN_DIR/bin/jamlab-bootstrap
if [ $? -ne 0 ]; then
    echo -e "[ Unable to clone bootstrap with $ANSIBLE_MAIN_DIR/bin/jamlab-bootstrap" >&2
    exit 1
fi

# Don't run jamlab-firstboot again
systemctl disable jamlab-firstboot.service

reboot
SCRIPT_EOF


cat << SERVICE_EOF > /etc/systemd/system/jamlab-firstboot.service
[Unit]
Description=jamlab-firstboot
Wants=network.target
After=network-online.target

[Service]
ExecStart=/etc/systemd/scripts/jamlab-firstboot
Type=oneshot

[Install]
WantedBy=multi-user.target
SERVICE_EOF


# Enable service
systemctl enable jamlab-firstboot.service

# Disable password access
sed -i -E 's/#?PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
