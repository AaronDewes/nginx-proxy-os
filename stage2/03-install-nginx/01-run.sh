#!/bin/bash -e

# This script:
# - Installs nginx's dependencies
# - Installs nginx

# Install Docker
# The version in Debian Bullseye is recent enough to be installed via apt
echo "Installing Docker and Docker Compose..."
echo
on_chroot << EOF
apt-get install docker.io -y
usermod -a -G docker $FIRST_USER_NAME
pip3 install docker-compose
EOF


# Bind Avahi to eth0,wlan0 interfaces to prevent hostname cycling
# https://github.com/getumbrel/umbrel-os/issues/76
echo "Binding Avahi to eth0 and wlan0 interfaces..."
on_chroot << EOF
sed -i "s/#allow-interfaces=eth0/allow-interfaces=eth0,wlan0/g;" "/etc/avahi/avahi-daemon.conf";
EOF

# Install nginx
echo "Installing nginx..."
echo

# Download nginx
mkdir /nginx
cd /nginx
git clone https://github.com/AaronDewes/nginx-proxy-manager .

install -m 644 "nginx-proxy-startup.service"   "${ROOTFS_DIR}/etc/systemd/system/nginx-proxy-startup.service"
on_chroot << EOF
systemctl enable "nginx-proxy-startup.service"
EOF

# Copy nginx to image
mkdir "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/nginx"
rsync --quiet --archive --partial --hard-links --sparse --xattrs /nginx "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/"

# Fix permissions
on_chroot << EOF
chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}/nginx/
EOF
