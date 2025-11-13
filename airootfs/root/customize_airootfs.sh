#!/bin/bash
# Custom setup script for blossomOS
# This script runs during the ISO boot process

echo "Setting up blossomOS..."

# Set up /etc/skel with default user configuration
chmod +x /etc/skel/.config/sway/status.sh
chmod +x /etc/skel/.config/sway/autorun.sh
chmod +x /etc/skel/.bashrc

# Create Live user
useradd liveuser
usermod -aG video,audio,optical,storage,wheel liveuser
echo "liveuser:*" | chpasswd -e
passwd -d liveuser
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
cp -ra /etc/skel/. /home/liveuser/
chown -R liveuser:liveuser /home/liveuser/

# Install themes and icons
git clone https://github.com/L4ki/Breeze-Chameleon-Icons /tmp/Breeze-Chameleon-Icons
cp -r /tmp/Breeze-Chameleon-Icons/* /usr/share/icons/
rm -rf /usr/share/icons/README.md
rm -rf /usr/share/icons/LICENSE
rm -rf /usr/share/icons/AUTHORS
rm -rf /usr/share/icons/.git
rm -rf /tmp/Breeze-Chameleon-Icons
wget -O /tmp/Bibata_Cursor.tar.gz https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Classic.tar.xz
tar -xvf /tmp/Bibata_Cursor.tar.gz -C /usr/share/icons/
rm -rf /tmp/Bibata_Cursor.tar.gz

# Set timezone to UTC (change as needed)
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Enable some useful services
systemctl enable NetworkManager

# Set hostname
echo "blossomos" > /etc/hostname

# Configure sudoers for wheel group
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

# Cleanup root fs
pacman -Rns --noconfirm $(pacman -Qdtq) || true
pacman -Scc --noconfirm
rm -rf /tmp/* /var/tmp/* /var/cache/*

echo "blossomOS setup complete!"