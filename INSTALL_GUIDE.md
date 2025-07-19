# 📥 Installation Guide - Notes CLI

Complete installation instructions for Windows, macOS, and Linux.

## 🚀 Quick Install (All Platforms)

```bash
git clone https://github.com/MarufHossain14/notes-cli.git
cd notes-cli
bash install.sh
```

---

## 📋 Prerequisites

### Required (All Platforms)

- **bash** - Shell environment
- **git** - To clone the repository
- **grep, sed, date, mkdir, cp, rm** - Basic Unix commands

### Optional (Recommended)

- **fzf** - For fuzzy search functionality
- **gpg** - For note encryption
- **git** - For note synchronization

---

## 🖥️ Platform-Specific Installation

### Windows

#### Option 1: WSL (Windows Subsystem for Linux) - **Recommended**

```bash
# 1. Install WSL (if not already installed)
# Open PowerShell as Administrator and run:
wsl --install

# 2. Restart your computer

# 3. Open WSL terminal and install Notes CLI
git clone https://github.com/MarufHossain14/notes-cli.git
cd notes-cli
bash install.sh

# 4. Test the installation
notes help
```

````

#### Option 2: Git Bash

```bash
# 1. Download and install Git for Windows
# https://git-scm.com/download/win

# 2. Open Git Bash and run:
git clone <your-repo-url>
cd notes-app
./install.sh

# 3. Restart Git Bash
````

#### Option 3: PowerShell (Limited Support)

```powershell
# 1. Install Chocolatey (if not installed)
# Run PowerShell as Administrator:
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# 2. Install dependencies
choco install git fzf gnupg

# 3. Clone and install
git clone <your-repo-url>
cd notes-app
bash install.sh
```

### macOS

#### Option 1: Homebrew (Recommended)

```bash
# 1. Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install dependencies
brew install git fzf gnupg

# 3. Clone and install Notes CLI
git clone <your-repo-url>
cd notes-app
./install.sh

# 4. Restart terminal or run:
source ~/.zshrc
```

#### Option 2: Manual Installation

```bash
# 1. Install Xcode Command Line Tools
xcode-select --install

# 2. Clone repository
git clone <your-repo-url>
cd notes-app

# 3. Manual setup
mkdir -p ~/.local/bin
ln -sf "$PWD/notes.sh" ~/.local/bin/notes
chmod +x ~/.local/bin/notes
cp .notesrc ~/.notesrc
mkdir -p ~/notes

# 4. Add to PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Linux

#### Ubuntu/Debian

```bash
# 1. Update package list
sudo apt update

# 2. Install dependencies
sudo apt install git fzf gnupg

# 3. Clone and install
git clone <your-repo-url>
cd notes-app
./install.sh

# 4. Restart terminal or run:
source ~/.bashrc
```

#### CentOS/RHEL/Fedora

```bash
# 1. Install dependencies
sudo yum install git fzf gnupg
# OR for Fedora:
sudo dnf install git fzf gnupg

# 2. Clone and install
git clone <your-repo-url>
cd notes-app
./install.sh

# 3. Restart terminal or run:
source ~/.bashrc
```

#### Arch Linux

```bash
# 1. Install dependencies
sudo pacman -S git fzf gnupg

# 2. Clone and install
git clone <your-repo-url>
cd notes-app
./install.sh

# 3. Restart terminal or run:
source ~/.bashrc
```

#### Other Linux Distributions

```bash
# 1. Install dependencies manually
# Check your package manager and install: git, fzf, gnupg

# 2. Clone and install
git clone <your-repo-url>
cd notes-app
./install.sh

# 3. Restart terminal or run:
source ~/.bashrc
```

---

## ⚙️ Post-Installation Setup

### 1. Verify Installation

```bash
notes version
notes help
```

### 2. Configure Settings

```bash
# Edit configuration file
nano ~/.notesrc

# Or use your preferred editor
code ~/.notesrc  # VS Code
vim ~/.notesrc   # Vim
```

### 3. Set Up GPG Encryption (Optional)

```bash
# Generate GPG key
gpg --full-generate-key

# Add your email to config
echo 'GPG_USER="your-email@example.com"' >> ~/.notesrc
```

### 4. Set Up Git Sync (Optional)

```bash
# Create a Git repository for your notes
cd ~/notes
git init
git remote add origin <your-repo-url>

# Test sync
notes sync
```

---

## 🧪 Test Your Installation

```bash
# 1. Add a test note
notes add
# Choose "Work" category and write: "Test note - installation successful!"

# 2. List your notes
notes list

# 3. Search for your note
notes search "test"

# 4. Check the dashboard
notes dashboard

# 5. Test plugins
notes plugins
```

---

## 📁 File Locations

After installation, these files will be created:

```
~/
├── .local/bin/notes          # Executable symlink
├── .notesrc                  # Configuration file
├── notes/                    # Notes directory
│   ├── work.txt             # Work notes
│   ├── personal.txt         # Personal notes
│   ├── journal-YYYY-MM-DD.txt # Daily journals
│   └── private/             # Encrypted notes
└── .notes_plugins/          # Plugin directory (in repo)
```

---

## 🔄 Updating Notes CLI

```bash
# Navigate to your installation directory
cd /path/to/notes-app

# Pull latest changes
git pull

# Re-run installer to update symlinks
./install.sh
```

---

## 🗑️ Uninstalling

```bash
# Run the uninstall script
./uninstall.sh

# Or manually remove:
rm ~/.local/bin/notes
rm ~/.notesrc
rm -rf ~/notes  # Only if you want to delete all notes
```

---

## ✅ Installation Checklist

- [ ] Repository cloned successfully
- [ ] `./install.sh` completed without errors
- [ ] `notes version` shows version number
- [ ] `notes help` displays help menu
- [ ] Configuration file created at `~/.notesrc`
- [ ] Notes directory created at `~/notes`
- [ ] Test note created successfully
- [ ] Search functionality works
- [ ] Dashboard displays correctly

---

## 🆘 Need Help?

If you encounter issues during installation:

1. Check the [Troubleshooting Guide](TROUBLESHOOTING.md)
2. Verify your system meets the prerequisites
3. Try the manual installation steps
4. Check the [README.md](README.md) for additional information

---

**🎉 Congratulations!** You've successfully installed Notes CLI and are ready to start taking notes!
