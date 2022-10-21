mkdir -p /etc/systemd/scripts

cat << SCRIPT_EOF > /etc/systemd/scripts/jamlab-firstboot
#!/bin/bash

# Set output
set -x
exec &> /var/log/jamlab_install.log

# Clone jamlab-ansible and bootstrap
/usr/bin/git clone https://github.com/JamFox/jamlab-ansible.git /opt/jamlab-ansible
if [ $? -ne 0 ]; then
    echo -e "[ Unable to clone https://github.com/JamFox/jamlab-ansible.git" >&2
    exit 1
fi

/opt/jamlab-ansible/bin/jamlab-bootstrap
if [ $? -ne 0 ]; then
    echo -e "[ Unable to bootstrap with /opt/jamlab-ansible/bin/jamlab-bootstrap" >&2
    exit 1
fi

# Don't run jamlab-firstboot again
/usr/bin/systemctl disable jamlab-firstboot.service

reboot
SCRIPT_EOF
chmod +x /etc/systemd/scripts/jamlab-firstboot


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
chmod +x /etc/systemd/system/jamlab-firstboot.service

# Enable service
systemctl enable jamlab-firstboot.service

# Disable password access
sed -i -E 's/#?PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
