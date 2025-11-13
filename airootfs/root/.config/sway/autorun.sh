#!/bin/bash

while true; do
    choice=$(yad --list --title="homeOS Recovery" \
        --text="Select an action:" \
        --column="Action" --column="Description" \
        "Timeshift" "Restore from backup" \
        "Installer" "(Re)install homeOS to disk" \
        "Terminal" "Open terminal" \
        "Browser" "Open web browser" \
        "Disk Utility" "Repair or erase a disk using GParted" \
        "Shutdown" "Power off system" \
        --width=400 --height=300 --print-column=1)

    # Debug
    echo "User selected: $choice"

    case "$choice" in
        "Installer")
            if [ -x "/usr/bin/homeos-installer" ]; then
                /usr/bin/homeos-installer
            else
                yad --error --text="homeOS installer not found"
            fi
            ;;
        "Timeshift")
            if [ -x "/usr/bin/timeshift" ]; then
                /usr/bin/timeshift
            else
                yad --error --text="Timeshift not found"
            fi
            ;;
        "Terminal")
            if [ -x "/usr/bin/kitty" ]; then
                /usr/bin/kitty
            else
                yad --error --text="Kitty terminal not found"
            fi
            ;;
        "Browser")
            if [ -x "/usr/bin/firefox" ]; then
                /usr/bin/firefox
            else
                yad --error --text="Firefox not found"
            fi
            ;;
        "Disk Utility")
            if [ -x "/usr/bin/gparted" ]; then
                /usr/bin/gparted
            else
                yad --error --text="GParted not found"
            fi
            ;;
        "Shutdown")
            if yad --question --text="Are you sure you want to shutdown?"; then
                /sbin/poweroff
            fi
            ;;
        *)
            break
            ;;
    esac
done
