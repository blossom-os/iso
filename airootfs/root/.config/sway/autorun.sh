#!/bin/bash

# homeOS Launcher - Zenity menu for common tasks

while true; do
    choice=$(zenity --list \
        --title="homeOS Launcher" \
        --text="Select an action:" \
        --column="Action" \
        --column="Description" \
        --width=400 \
        --height=300 \
        "Installer" "Install homeOS to disk" \
        "Timeshift" "System backup and restore" \
        "Terminal" "Open terminal" \
        "Browser" "Open web browser" \
        "Shutdown" "Power off system" \
        2>/dev/null)

    case "$choice" in
        "Installer")
            if [ -x "/usr/bin/homeos-installer" ]; then
                /usr/bin/homeos-installer &
            else
                zenity --error --text="homeOS installer not found" 2>/dev/null
            fi
            ;;
        "Timeshift")
            if [ -x "/usr/bin/timeshift" ]; then
                /usr/bin/timeshift &
            else
                zenity --error --text="Timeshift not found" 2>/dev/null
            fi
            ;;
        "Terminal")
            if [ -x "/usr/bin/kitty" ]; then
                /usr/bin/kitty &
            else
                zenity --error --text="Kitty terminal not found" 2>/dev/null
            fi
            ;;
        "Browser")
            if [ -x "/usr/bin/firefox" ]; then
                /usr/bin/firefox &
            else
                zenity --error --text="Firefox not found" 2>/dev/null
            fi
            ;;
        "Shutdown")
            if zenity --question --text="Are you sure you want to shutdown?" 2>/dev/null; then
                /sbin/poweroff
            fi
            ;;
        *)
            # User cancelled or closed dialog
            break
            ;;
    esac
done