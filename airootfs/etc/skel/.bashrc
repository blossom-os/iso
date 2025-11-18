#!/bin/bash

# Auto-start Sway on TTY1
if [ -z "$WAYLAND_DISPLAY" ]; then
    # Ensure a runtime dir exists for the root session
    export XDG_RUNTIME_DIR="/run/user/$(id -u)"
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR" || true

    # Ensure sudo works properly by clearing any restrictive flags
    export SUDO_FORCE_REMOVE=yes

    # Fix Polkit authentication issues
    export QT_QPA_PLATFORM=wayland

    # Start Sway inside a dbus session for session services
    exec dbus-run-session -- /usr/bin/sway --unsupported-gpu
fi
