#!/bin/bash

# blossomOS Local ISO Builder
# Builds the ISO locally using Docker and outputs to current directory

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ISO_NAME="${ISO_NAME:-blossomOS}"
CONTAINER_NAME="blossomOS-builder"

# Functions
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

cleanup() {
    log "Cleaning up..."
    docker rm -f "$CONTAINER_NAME" 2>/dev/null || true
}

# Set up cleanup on exit
trap cleanup EXIT

# Check if we're in the right directory
if [ ! -f "packages.x86_64" ] || [ ! -d "airootfs" ]; then
    error "This script must be run from the blossomOS iso repository root directory"
    error "Make sure packages.x86_64 and airootfs/ exist"
    exit 1
fi

# Get current working directory
REPO_DIR="$(pwd)"
OUTPUT_DIR="$REPO_DIR"

log "Starting blossomOS ISO build..."
log "Repository: $REPO_DIR"
log "Output: $OUTPUT_DIR"
log "ISO Name: $ISO_NAME"

# Clean up any existing container
cleanup

# Create and start Arch Linux container
log "Setting up Arch Linux build environment..."
docker run --privileged -d \
    --name "$CONTAINER_NAME" \
    --volume "$REPO_DIR:/workspace" \
    --volume "/tmp:/tmp" \
    archlinux:latest tail -f /dev/null

# Update system and install required packages
log "Installing build dependencies..."
docker exec "$CONTAINER_NAME" pacman -Syu --noconfirm
docker exec "$CONTAINER_NAME" pacman -S --noconfirm archiso git base-devel wget curl

# Prepare archiso profile
log "Preparing archiso profile..."
docker exec "$CONTAINER_NAME" bash -c "
    set -e
    cd /workspace
    
    # Copy the releng profile as a base
    cp -r /usr/share/archiso/configs/releng ./archiso-config
    
    # Copy custom boot files if they exist
    if [ -d /workspace/archiso-custom ]; then
        cp -r /workspace/archiso-custom/ ./archiso-config/work/iso/boot
        rm -f ./archiso-config/work/iso/boot/efiboot/loader/entries/02-archiso-speech-linux.conf
        rm -f ./archiso-config/work/iso/boot/syslinux/splash.png
    fi

    # Install grub
    pacman -Sy --noconfirm grub
    
    cd archiso-config
    
    # Update profile name and label
    sed -i 's/iso_name=\"archlinux\"/iso_name=\"$ISO_NAME\"/' profiledef.sh
    sed -i 's/iso_label=\"ARCH_\$(date +%Y%m)\"/iso_label=\"$(echo $ISO_NAME | tr '[:lower:]' '[:upper:]')_\$(date +%Y%m)\"/' profiledef.sh
    
    # Add custom packages
    if [ -f /workspace/packages.x86_64 ]; then
        echo 'Adding custom packages...'
        cat /workspace/packages.x86_64 >> packages.x86_64
    fi
    
    # Copy custom filesystem overlay
    if [ -d /workspace/airootfs ]; then
        echo 'Copying filesystem overlay...'
        cp -r /workspace/airootfs/* airootfs/ 2>/dev/null || true
    fi
    
    # Set executable permissions on scripts
    find airootfs -type f -name '*.sh' -exec chmod +x {} \\;
    
    echo 'Profile preparation complete!'
"

# Build the ISO
log "Building ISO (this may take a while)..."
docker exec "$CONTAINER_NAME" bash -c "
    set -e
    cd /workspace/archiso-config
    
    echo 'Starting mkarchiso...'
    mkarchiso -v -w work -o out .
    
    echo 'ISO build complete!'
    ls -la out/
"

# Copy ISO to current directory
log "Copying ISO to output directory..."
docker exec "$CONTAINER_NAME" bash -c "
    cd /workspace/archiso-config/out
    cp *.iso /workspace/
"

# Get ISO info
ISO_FILE=$(ls *.iso 2>/dev/null | head -n 1)
if [ -n "$ISO_FILE" ]; then
    ISO_SIZE=$(du -h "$ISO_FILE" | cut -f1)
    success "ISO build completed successfully!"
    success "File: $ISO_FILE"
    success "Size: $ISO_SIZE"
    success "Location: $OUTPUT_DIR/$ISO_FILE"
else
    error "ISO file not found after build"
    exit 1
fi

# Clean up
cleanup

log "Build process finished!"
log "You can now test the ISO with: qemu-system-x86_64 -m 2G -cdrom $ISO_FILE"