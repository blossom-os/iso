#!/bin/bash

# Auto-start Sway on TTY1
if [ -z "$WAYLAND_DISPLAY" ]; then
    # Ensure a runtime dir exists for the root session
    export XDG_RUNTIME_DIR="/run/user/$(id -u)"
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR" || true

    # Start Sway inside a dbus session for session services
    exec dbus-run-session -- /usr/bin/sway
fi

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
