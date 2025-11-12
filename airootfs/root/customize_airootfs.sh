#!/bin/bash
# Custom setup script for homeOS
# This script runs during the ISO boot process

echo "Setting up homeOS..."

# Set timezone to UTC (change as needed)
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Enable some useful services
systemctl enable NetworkManager

# Set hostname
echo "homeOS-live" > /etc/hostname

# Configure sudoers for wheel group
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

# Create a script to auto-start Sway
chmod +x /root/.config/sway/status.sh
chmod +x /root/.config/sway/autorun.sh
cat > /root/.bash_profile << 'EOF'
# Auto-start Sway on TTY1
if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    # Ensure a runtime dir exists for the root session
    export XDG_RUNTIME_DIR="/run/user/0"
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR" || true

    # Start Sway inside a dbus session for session services
    exec dbus-run-session -- /usr/bin/sway
fi
EOF

# Set up Sway configuration directory
mkdir -p /root/.config/sway

echo "homeOS setup complete!"