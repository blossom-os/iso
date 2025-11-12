#!/bin/bash
# Custom setup script for homeOS
# This script runs during the ISO boot process

echo "Setting up homeOS..."

# Set timezone to UTC (change as needed)
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Enable some useful services
systemctl enable NetworkManager

# Set hostname
echo "homeos" > /etc/hostname

# Configure sudoers for wheel group
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

# Create a script to auto-start Sway
chmod +x /root/.config/sway/status.sh
chmod +x /root/.config/sway/autorun.sh
chmod +x /root/.bash_profile

# Cleanup root fs
pacman -Rns --noconfirm $(pacman -Qdtq) || true
pacman -Scc --noconfirm
rm -rf /tmp/* /var/tmp/* /var/cache/*

# Set up Sway configuration directory
mkdir -p /root/.config/sway

echo "homeOS setup complete!"