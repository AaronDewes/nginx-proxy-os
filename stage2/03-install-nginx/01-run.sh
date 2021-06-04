#!/bin/bash -e

# This script:
# - Installs nginx's dependencies
# - Installs nginx

# Install Docker
echo "Installing Docker..."
echo
on_chroot << EOF
curl -fsSL https://get.docker.com | sh
usermod -a -G docker $FIRST_USER_NAME
EOF

# Install Docker Compose with pip3
echo "Installing Docker Compose..."
echo
on_chroot << EOF
pip3 install docker-compose
EOF

# Bind Avahi to eth0,wlan0 interfaces to prevent hostname cycling
# https://github.com/getnginx/nginx-os/issues/76
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

# Bundle nginx's Docker images
echo "Pulling nginx's Docker images..."
echo
cd /nginx
IMAGES=$(grep '^\s*image' docker-compose.yml | sed 's/image://' | sed 's/\"//g' | sed '/^$/d;s/[[:blank:]]//g' | sort | uniq)
echo
echo "Images to bundle: $IMAGES"
echo

while IFS= read -r image; do
    docker pull --platform=linux/arm64 $image
done <<< "$IMAGES"

# Copy the entire /var/lib/docker directory to image
mkdir -p ${ROOTFS_DIR}/var/lib/docker
rsync --quiet --archive --partial --hard-links --sparse --xattrs /var/lib/docker ${ROOTFS_DIR}/var/lib/
