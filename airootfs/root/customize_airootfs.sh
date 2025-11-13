#!/bin/bash
# Custom setup script for homeOS
# This script runs during the ISO boot process

echo "Setting up homeOS..."

# Create Live user
useradd -m -G wheel liveuser
echo "liveuser:live" | chpasswd
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Add repos
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
pacman -Syu --noconfirm

# Install yay and xfce-polkit
pacman -S --noconfirm yay
su - liveuser -c "yay -S --noconfirm xfce-polkit"

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
echo "homeos" > /etc/hostname

# Configure sudoers for wheel group
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

# Create a script to auto-start Sway
chmod +x /root/.config/sway/status.sh
chmod +x /root/.config/sway/autorun.sh
chmod +x /etc/profile.d/recovery

# Cleanup root fs
pacman -Rns --noconfirm $(pacman -Qdtq) || true
pacman -Scc --noconfirm
rm -rf /tmp/* /var/tmp/* /var/cache/*

# Set up Sway configuration directory
mkdir -p /root/.config/sway

echo "homeOS setup complete!"