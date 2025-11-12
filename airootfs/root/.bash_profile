#!/bin/bash

# Auto-start Sway on TTY1
if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    # Ensure a runtime dir exists for the root session
    export XDG_RUNTIME_DIR="/run/user/0"
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR" || true

    # Start Sway inside a dbus session for session services
    exec dbus-run-session -- /usr/bin/sway
fi