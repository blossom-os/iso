# homeOS - Custom Arch Linux ISO

This repository contains the configuration and GitHub Actions workflow to build a custom Arch Linux ISO called "homeOS".

## Features

- Automated ISO building using GitHub Actions
- **Sway Wayland desktop environment** with auto-login as root
- **Chaotic AUR integration** with pre-installed yay AUR helper
- **Multilib support** enabled by default
- Customizable package selection
- Custom configuration and scripts
- Automatic artifact upload and release creation
- **Audio support** with PipeWire

## Usage

### Building the ISO

The ISO is automatically built on:
- Push to main/master branch
- Pull requests to main/master branch
- Manual workflow dispatch

#### Manual Build

You can trigger a manual build from the GitHub Actions tab with these options:
- **Custom ISO name**: Override the default "homeOS" name
- **Include AUR packages**: Legacy option (Chaotic AUR is now enabled by default)

### Customization

#### Adding Packages

Edit `packages.x86_64` to add additional packages to your ISO:
```
vim
firefox
docker
python
```

#### Custom Files and Scripts

Place custom files in the `airootfs/` directory structure. They will be copied to the root filesystem of the ISO.

Example:
- `airootfs/etc/` - Configuration files
- `airootfs/home/` - User files
- `airootfs/root/` - Root user files and scripts

#### Custom Setup Script

The `airootfs/root/customize_airootfs.sh` script runs during ISO creation. Modify it to:
- Configure services
- Set up users
- Install additional software
- Configure system settings

### Workflow Details

The GitHub Action workflow:

1. **Environment Setup**: Creates an Arch Linux container
2. **Profile Preparation**: Copies and customizes the archiso profile
3. **Package Installation**: Adds packages from `packages.x86_64`
4. **Custom Files**: Copies files from `airootfs/`
5. **ISO Building**: Uses `mkarchiso` to create the ISO
6. **Artifact Upload**: Saves the ISO as a GitHub artifact
7. **Release Creation**: Creates a release if triggered by a tag

### File Structure

```
.
├── .github/workflows/
│   └── build-arch-iso.yml     # GitHub Actions workflow
├── airootfs/                  # Custom files for the ISO
│   └── root/
│       └── customize_airootfs.sh
├── packages.x86_64            # Additional packages
└── README.md
```

### Requirements

- GitHub repository
- GitHub Actions enabled
- Approximately 2-4 GB of storage for artifacts

### Built ISO Features

The resulting ISO includes:
- **Sway Wayland desktop environment** with minimal configuration
- **Auto-login as root** directly into Sway desktop
- Standard Arch Linux base system
- **Chaotic AUR repository** pre-configured with yay AUR helper
- **Multilib repository** enabled for 32-bit application support
- **PipeWire audio system** with ALSA and PulseAudio compatibility
- **Basic terminal applications**: Alacritty, Foot terminal emulators
- **Application launcher**: Wofi for launching applications
- Additional packages from `packages.x86_64`
- Custom configurations and scripts
- NetworkManager and SSH enabled

### Desktop Environment

The homeOS ISO boots directly into a **Sway Wayland desktop environment** with:
- **Tiling window manager** optimized for keyboard use
- **Super+Return**: Opens terminal (Alacritty)
- **Super+D**: Application launcher (Wofi)
- **Super+Shift+Q**: Close window
- **Super+Shift+E**: Exit Sway
- **Super+R**: Resize mode
- **Super+1-9**: Switch workspaces
- Basic status bar showing date/time

### Download

After a successful build:
1. Go to the "Actions" tab
2. Click on the latest workflow run
3. Download the ISO from the "Artifacts" section

For tagged releases, the ISO will also be available in the "Releases" section.

### Advanced Configuration

For more advanced customization, you can modify the archiso profile directly in the workflow or create a custom profile in your repository.

## Contributing

1. Fork the repository
2. Make your changes
3. Test the build process
4. Create a pull request

## License

This project is open source. See the Arch Linux and archiso licenses for the underlying components.