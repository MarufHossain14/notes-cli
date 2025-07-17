# 📝 Notes CLI

A powerful, feature-rich terminal-based note-taking application with encryption, backup, sync, and plugin support. Perfect for personal use and sharing with friends.

## ✨ Features

### Core Features

- **📝 Note Management**: Create, edit, delete, and organize notes by categories
- **📓 Daily Journaling**: Automatic daily journal entries with timestamps
- **🔍 Smart Search**: Search across all notes with keyword and tag filtering
- **🎯 Fuzzy Search**: Interactive file selection with fzf (optional)
- **🏷️ Tag System**: Use hashtags to organize and filter notes
- **📤 Export**: Export notes to Markdown format
- **💾 Auto Backup**: Automatic backup creation with retention management
- **🔄 Git Sync**: Version control and cloud sync with Git

### Security Features

- **🔐 GPG Encryption**: Encrypt sensitive notes with GPG
- **🔒 Private Directory**: Separate encrypted notes storage
- **🛡️ Safe Filenames**: Automatic sanitization of file names

### Plugin System

- **🌤️ Weather**: Current weather information
- **⏰ Reminders**: Set and manage reminders
- **🔋 System Status**: Battery, uptime, and disk usage
- **🌐 Network**: Network connectivity and IP information
- **📅 Calendar**: Date information and weekly view
- **📊 Statistics**: Note statistics and analytics
- **💾 Backup**: Manual backup operations

### Themes & Customization

- **🎨 Multiple Themes**: Default, Solarized, Gruvbox, Dracula
- **⚙️ Configurable**: Easy configuration via `~/.notesrc`
- **🔧 Extensible**: Plugin system for custom functionality

## 🚀 Quick Start

### Prerequisites

- **Required**: bash, grep, sed, date, mkdir, cp, rm
- **Optional**: fzf (fuzzy search), gpg (encryption), git (sync)

### Installation

#### Option 1: Automated Install (Recommended)

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/notes-app.git
cd notes-app

# Run the installer
./install.sh
```

#### Option 2: Manual Install

```bash
# Clone and setup
git clone https://github.com/YOUR_USERNAME/notes-app.git
cd notes-app
chmod +x notes.sh

# Create symlink
mkdir -p ~/.local/bin
ln -sf "$PWD/notes.sh" ~/.local/bin/notes

# Add to PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="$HOME/.local/bin:$PATH"

# Copy configuration
cp .notesrc ~/.notesrc
```

### First Time Setup

1. **Restart your terminal** or run `source ~/.bashrc`

2. **Configure your settings**:

   ```bash
   nano ~/.notesrc
   ```

3. **Set up GPG for encryption** (optional):

   ```bash
   gpg --full-generate-key
   # Add your GPG email to ~/.notesrc
   ```

4. **Configure Git sync** (optional):
   ```bash
   cd ~/notes
   git remote add origin <your-repo-url>
   ```

## 📖 Usage

### Basic Commands

```bash
notes add          # Add a new note
notes list         # List notes in a category
notes journal      # Write today's journal
notes search       # Search all notes
notes help         # Show help
```

### Advanced Commands

```bash
notes fuzzy        # Interactive file selection
notes encrypt      # Create encrypted note
notes decrypt      # View encrypted note
notes sync         # Sync to Git
notes dashboard    # Show daily summary
notes config       # Show configuration
```

### Examples

#### Adding Notes

```bash
# Add a work note
notes add
# Choose "Work" category and write your note

# Add to today's journal
notes journal
# Write your daily thoughts
```

#### Searching

```bash
# Search for "meeting" in all notes
notes search meeting

# Search for notes with #work tag
notes tag #work

# Interactive fuzzy search
notes fuzzy
```

#### Encryption

```bash
# Create an encrypted note
notes encrypt
# Enter title and content

# View encrypted notes
notes decrypt
```

#### Sync

```bash
# Sync all notes to Git
notes sync

# Check sync status
notes dashboard
```

## ⚙️ Configuration

Edit `~/.notesrc` to customize your setup:

```bash
# Theme options: default, solarized, gruvbox, dracula
THEME="default"

# Your preferred editor
EDITOR="nano"

# Notes directory
NOTES_DIR="$HOME/notes"

# GPG email for encryption
GPG_USER="your-email@example.com"

# Auto sync after operations
AUTO_SYNC=false

# Backup retention (days)
BACKUP_RETENTION_DAYS=7
```

## 🔌 Plugins

### Built-in Plugins

- **weather**: Current weather information
- **reminder**: Set and manage reminders
- **battery**: System status and battery info
- **network**: Network connectivity status
- **calendar**: Date and calendar information
- **stats**: Note statistics and analytics
- **backup**: Manual backup operations

### Using Plugins

```bash
# Run all plugins
notes plugins

# Run specific plugin
notes weather
notes reminder
notes stats
```

### Creating Custom Plugins

Create `.sh` files in `.notes_plugins/` directory:

```bash
#!/usr/bin/env bash
# My custom plugin
echo "🔧 Custom Plugin:"
echo "  Hello from my plugin!"
```

## 📁 File Structure

```
~/
├── notes/                 # Your notes directory
│   ├── work.txt          # Work notes
│   ├── personal.txt      # Personal notes
│   ├── journal-2024-01-15.txt  # Daily journals
│   ├── private/          # Encrypted notes
│   └── backups/          # Manual backups
├── .notesrc              # Configuration file
└── .local/bin/notes      # Executable symlink
```

## 🔧 Troubleshooting

### Common Issues

**"Command not found: notes"**

- Ensure `~/.local/bin` is in your PATH
- Restart your terminal or run `source ~/.bashrc`

**"fzf not found"**

- Install fzf: `sudo apt install fzf` (Ubuntu) or `brew install fzf` (macOS)

**"GPG encryption failed"**

- Generate a GPG key: `gpg --full-generate-key`
- Set GPG_USER in `~/.notesrc`

**"Git sync not working"**

- Initialize Git: `cd ~/notes && git init`
- Add remote: `git remote add origin <your-repo-url>`

### Getting Help

```bash
notes help          # Show command help
notes config        # Show current configuration
notes version       # Show version information
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- Built with bash scripting
- Uses [fzf](https://github.com/junegunn/fzf) for fuzzy search
- Weather data from [wttr.in](https://wttr.in)
- Inspired by various CLI note-taking tools
