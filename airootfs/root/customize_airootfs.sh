#!/bin/bash
# Custom setup script for blossomOS
# This script runs during the ISO boot process

echo "Setting up blossomOS..."

# Set up /etc/skel with default user configuration
chmod +x /etc/skel/.bashrc
chmod +x /usr/bin/encodesn

# Create Live user
useradd liveuser
usermod -aG video,audio,optical,storage,wheel liveuser
echo "liveuser:*" | chpasswd -e
passwd -d liveuser
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
cp -ra /etc/skel/. /home/liveuser/
chown -R liveuser:liveuser /home/liveuser/

# Set up installer
sudo -u liveuser bash -c 'curl -fsSL https://bun.sh/install | bash'
cd /opt
git clone https://github.com/blossom-os/installer.git blossomos-installer
chown -R liveuser:liveuser /opt/blossomos-installer
sudo -u liveuser bash -c 'cd /opt/blossomos-installer && /home/liveuser/.bun/bin/bun install'
chmod +x /opt/blossomos-installer/start.sh
python -m pip install konsave --break-system-packages # This is intentional to ensure konsave is available system-wide
sudo -u liveuser bash -c 'konsave -i /usr/share/blossomos/theme.knsv'
sudo -u liveuser bash -c 'konsave -a theme'

# Install themes and icons
wget -O /tmp/Bibata_Cursor.tar.gz https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Classic.tar.xz
tar -xvf /tmp/Bibata_Cursor.tar.gz -C /usr/share/icons/
rm -rf /tmp/Bibata_Cursor.tar.gz

# Set timezone to UTC (change as needed)
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Enable some useful services
systemctl enable NetworkManager
systemctl enable sddm

# Set hostname
echo "blossomos" > /etc/hostname

# Configure sudoers for wheel group - ensure proper permissions
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

# Ensure sudo can escalate privileges properly
echo "Set disable_coredump false" >> /etc/sudo.conf

# Cleanup root fs
pacman -Rns --noconfirm $(pacman -Qdtq) || true
pacman -Scc --noconfirm
rm -rf /tmp/* /var/tmp/* /var/cache/*

echo "blossomOS setup complete!"