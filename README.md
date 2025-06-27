
# ScriptSpinnah

A lightweight macOS menu bar app for quickly executing shell scripts on specific folders. Perfect for developers, power users, and anyone who regularly runs scripts as part of their workflow.

## Features

- **Menu Bar Access**: Lives in your menu bar for instant access
- **Script-Folder Pairings**: Associate any shell script with a target folder
- **One-Click Execution**: Run your scripts with a single click
- **Custom Names**: Give your pairings memorable display names
- **Security Focused**: Uses macOS security-scoped bookmarks for safe file access
- **Modern UI**: Beautiful translucent interface with native macOS styling

## Perfect For

- **Developers**: Quickly run build scripts, deployment tools, or code generators
- **Power Users**: Automate routine file operations and system tasks
- **Anyone**: Who has repetitive processes that can be scripted

## Requirements

- macOS 15 (Sequoia) or later

## Installation

1. Download the latest release from [Releases](../../releases)
2. Open the `.dmg` file
3. Drag ScriptSpinnah to your Applications folder
4. Launch ScriptSpinnah
5. Grant necessary permissions when prompted

## Usage

### Setting Up Your First Script Pairing

1. Click the ScriptSpinnah icon in your menu bar
2. Select "Open Settings"
3. Choose a target folder where your script will operate
4. Click "Add Pairing..." and select your shell script
5. Optionally, give it a custom display name
6. Click outside the settings to save

### Running Scripts

1. Click the ScriptSpinnah menu bar icon
2. Click on any script pairing to execute it
3. The script runs with the paired folder path as its first argument

### Script Requirements

Your shell scripts should:
- Accept a folder path as the first argument (`$1`)
- Be executable (`chmod +x your-script.sh`)
- Use `#!/bin/zsh` or `#!/bin/bash` shebang

Example script:
```bash
#!/bin/zsh
echo "Running script on folder: $1"
cd "$1"
# Your script logic here
```

## Building from Source

1. Clone this repository
2. Open `ScriptSpinnah.xcodeproj` in Xcode 15 or later
3. Build and run

## License

MIT License - see [LICENSE](LICENSE) for details

## Support

Found a bug or have a feature request? Please [open an issue](../../issues).

---

Made with ❤️ for the macOS automation community
