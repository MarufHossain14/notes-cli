# 🔧 Troubleshooting Guide - Notes CLI

Solutions for common installation and usage issues.

---

## 🚨 Installation Issues

### **Error: Command not found after installation**

**Problem:** The `notes` command is not in your PATH.

**Solutions:**

```bash
# Check if the symlink exists
ls -la ~/.local/bin/notes

# If missing, recreate the symlink
ln -sf /path/to/notes-cli/notes.sh ~/.local/bin/notes

# Add to PATH if not already there
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Test
notes help
```

### **Error: Colors showing as escape sequences (like \e[32m)**

**Problem:** Terminal doesn't support color codes or script has wrong shebang.

**Solutions:**

```bash
# Check bash path
which bash

# Update shebang if needed (edit first line of notes.sh)
#!/usr/bin/bash  # or whatever path 'which bash' shows

# Make executable
chmod +x notes.sh

# Test
bash notes.sh help
```

### **Error: `/usr/bin/env: 'bash\r': No such file or directory`**

**Problem:** Windows line endings (CRLF) instead of Unix line endings (LF).

**Solutions:**

#### Option 1: Fix line endings in WSL/Linux (Recommended)

```bash
# Convert line endings
sed -i 's/\r$//' install.sh
sed -i 's/\r$//' notes.sh

# Make executable
chmod +x install.sh notes.sh

# Try installation again
bash install.sh
```

#### Option 2: Use PowerShell to fix line endings

```powershell
# In PowerShell (Windows)
(Get-Content install.sh -Raw) -replace "`r`n", "`n" | Set-Content install.sh -NoNewline
(Get-Content notes.sh -Raw) -replace "`r`n", "`n" | Set-Content notes.sh -NoNewline
```

git add .
git commit -m "Fix line endings"

````

#### Option 4: Manual Fix

```bash
# Use dos2unix (install if needed)
dos2unix *.sh
dos2unix .notes_plugins/*.sh
````

### **Error: `Permission denied`**

**Problem:** Script files are not executable.

**Solution:**

```bash
chmod +x install.sh
chmod +x notes.sh
chmod +x .notes_plugins/*.sh
```

### **Error: `Command not found: notes`**

**Problem:** The `notes` command is not in your PATH.

**Solutions:**

#### Check if symlink exists:

```bash
ls -la ~/.local/bin/notes
```

#### Recreate symlink:

```bash
mkdir -p ~/.local/bin
ln -sf "$PWD/notes.sh" ~/.local/bin/notes
```

#### Add to PATH manually:

```bash
# For bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# For zsh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### **Error: `Missing required dependencies`**

**Problem:** Required commands are not installed.

**Solutions:**

#### Install on Ubuntu/Debian:

```bash
sudo apt update
sudo apt install bash grep sed coreutils
```

#### Install on CentOS/RHEL:

```bash
sudo yum install bash grep sed coreutils
```

#### Install on macOS:

```bash
# Install Xcode Command Line Tools
xcode-select --install
```

#### Install on Windows (WSL):

```bash
sudo apt update
sudo apt install bash grep sed coreutils
```

---

## 🔧 Runtime Issues

### **Error: `fzf not found`**

**Problem:** Fuzzy search dependency is missing.

**Solutions:**

#### Install fzf:

```bash
# Ubuntu/Debian
sudo apt install fzf

# CentOS/RHEL
sudo yum install fzf

# macOS
brew install fzf

# Windows (Chocolatey)
choco install fzf

# Manual installation
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

#### Use without fzf:

```bash
# Use regular search instead
notes search "keyword"
```

### **Error: `GPG encryption failed`**

**Problem:** GPG is not properly configured.

**Solutions:**

#### Install GPG:

```bash
# Ubuntu/Debian
sudo apt install gnupg

# CentOS/RHEL
sudo yum install gnupg

# macOS
brew install gnupg

# Windows (Chocolatey)
choco install gnupg
```

#### Generate GPG key:

```bash
gpg --full-generate-key
# Follow the prompts to create a key
```

#### Configure GPG in Notes CLI:

```bash
# Edit your config file
nano ~/.notesrc

# Add your GPG email:
GPG_USER="your-email@example.com"
```

#### Test GPG:

```bash
# List your keys
gpg --list-keys

# Test encryption
echo "test" | gpg --encrypt --recipient "your-email@example.com"
```

### **Error: `Git sync not working`**

**Problem:** Git repository is not properly configured.

**Solutions:**

#### Initialize Git repository:

```bash
cd ~/notes
git init
git config user.name "Your Name"
git config user.email "your-email@example.com"
```

#### Add remote repository:

```bash
git remote add origin <your-repo-url>
```

#### Test Git sync:

```bash
notes sync
```

#### Manual Git operations:

```bash
cd ~/notes
git add .
git commit -m "Initial commit"
git push -u origin main
```

### **Error: `Cannot access notes directory`**

**Problem:** Notes directory doesn't exist or has wrong permissions.

**Solution:**

```bash
# Create notes directory
mkdir -p ~/notes

# Set proper permissions
chmod 755 ~/notes

# Check if directory exists
ls -la ~/notes
```

---

## 🌐 Plugin Issues

### **Weather plugin not working**

**Problem:** Network connectivity or curl issues.

**Solutions:**

#### Check internet connection:

```bash
ping -c 1 8.8.8.8
```

#### Install curl:

```bash
# Ubuntu/Debian
sudo apt install curl

# CentOS/RHEL
sudo yum install curl

# macOS
brew install curl
```

#### Test weather service:

```bash
curl -s 'wttr.in/?format=3'
```

### **Battery plugin not showing info**

**Problem:** System-specific battery information not available.

**Solutions:**

#### Check if battery files exist:

```bash
ls /sys/class/power_supply/
```

#### Manual battery check:

```bash
# Linux
cat /sys/class/power_supply/BAT0/capacity

# macOS
pmset -g batt
```

### **Network plugin issues**

**Problem:** Network commands not available or different on your system.

**Solutions:**

#### Install network tools:

```bash
# Ubuntu/Debian
sudo apt install iproute2 net-tools

# CentOS/RHEL
sudo yum install iproute net-tools
```

#### Test network manually:

```bash
# Check connectivity
ping -c 1 8.8.8.8

# Get IP address
ip addr show
# OR
ifconfig
```

---

## 📁 File and Permission Issues

### **Error: `Cannot create backup`**

**Problem:** Insufficient permissions or disk space.

**Solutions:**

#### Check disk space:

```bash
df -h ~/notes
```

#### Check permissions:

```bash
ls -la ~/notes
```

#### Fix permissions:

```bash
chmod 755 ~/notes
chown $USER:$USER ~/notes
```

### **Error: `Configuration file not found`**

**Problem:** Configuration file was not created during installation.

**Solution:**

```bash
# Copy default configuration
cp /path/to/notes-app/.notesrc ~/.notesrc

# Or create manually
cat > ~/.notesrc << EOF
THEME="default"
EDITOR="nano"
NOTES_DIR="\$HOME/notes"
GPG_USER=""
AUTO_SYNC=false
BACKUP_RETENTION_DAYS=7
EOF
```

---

## 🔄 Sync and Backup Issues

### **Error: `Git push failed`**

**Problem:** Remote repository issues or authentication problems.

**Solutions:**

#### Check remote configuration:

```bash
cd ~/notes
git remote -v
```

#### Set up authentication:

```bash
# For HTTPS (recommended)
git config credential.helper store

# For SSH
ssh-keygen -t ed25519 -C "your-email@example.com"
# Add public key to your Git provider
```

#### Test connection:

```bash
# For HTTPS
git ls-remote origin

# For SSH
ssh -T git@github.com
```

### **Error: `Backup restoration failed`**

**Problem:** Backup file corruption or missing files.

**Solutions:**

#### Check backup files:

```bash
ls -la ~/notes/backup_*
```

#### Manual restoration:

```bash
# Find backup file
find ~/notes -name "backup_*" -type f

# Restore manually
cp ~/notes/backup_filename ~/notes/original_filename
```

---

## 🖥️ Platform-Specific Issues

### **Windows Issues**

#### WSL not working:

```bash
# Enable WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Restart computer, then:
wsl --install
```

#### Git Bash issues:

```bash
# Reinstall Git for Windows
# Download from: https://git-scm.com/download/win
```

### **macOS Issues**

#### Homebrew not working:

```bash
# Reinstall Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Permission issues:

```bash
# Fix permissions
sudo chown -R $(whoami) /usr/local/bin /usr/local/lib /usr/local/sbin
chmod u+w /usr/local/bin /usr/local/lib /usr/local/sbin
```

### **Linux Issues**

#### Package manager issues:

```bash
# Update package lists
sudo apt update  # Ubuntu/Debian
sudo yum update  # CentOS/RHEL
sudo pacman -Syu # Arch Linux
```

#### Missing dependencies:

```bash
# Install build tools
sudo apt install build-essential  # Ubuntu/Debian
sudo yum groupinstall "Development Tools"  # CentOS/RHEL
```

---

## 🐛 Debugging

### **Enable Debug Mode**

```bash
# Run with debug output
bash -x notes.sh help
```

### **Check Script Paths**

```bash
# Verify script locations
which notes
ls -la ~/.local/bin/notes
ls -la /path/to/notes-app/notes.sh
```

### **Check Environment**

```bash
# Check PATH
echo $PATH

# Check shell
echo $SHELL

# Check user
whoami
```

### **Test Individual Components**

```bash
# Test basic commands
bash -c 'echo "Test"'
grep --version
sed --version

# Test optional commands
fzf --version
gpg --version
git --version
```

---

## 📞 Getting Help

### **Before Asking for Help**

1. **Check this troubleshooting guide**
2. **Run the debug commands above**
3. **Check your system requirements**
4. **Try the manual installation steps**

### **Information to Provide**

When asking for help, include:

- **Operating System:** Windows/macOS/Linux version
- **Shell:** bash/zsh/powershell
- **Error Message:** Exact error text
- **Steps Taken:** What you tried
- **Debug Output:** Results from debug commands

### **Useful Commands for Diagnosis**

```bash
# System information
uname -a
cat /etc/os-release

# Shell information
echo $SHELL
echo $PATH

# Notes CLI information
notes version
notes config

# File locations
ls -la ~/.notesrc
ls -la ~/notes
ls -la ~/.local/bin/notes
```

---

## ✅ Quick Fix Checklist

- [ ] Fixed line endings (if on Windows)
- [ ] Made scripts executable (`chmod +x`)
- [ ] Added `~/.local/bin` to PATH
- [ ] Created `~/notes` directory
- [ ] Installed required dependencies
- [ ] Configured GPG (if using encryption)
- [ ] Set up Git repository (if using sync)
- [ ] Tested basic functionality

---

**🎯 Most Common Solutions:**

1. **Line ending issues** → Use `sed -i 's/\r$//' filename`
2. **Permission issues** → Use `chmod +x filename`
3. **PATH issues** → Add `~/.local/bin` to your shell config
4. **Dependency issues** → Install missing packages
5. **Configuration issues** → Check `~/.notesrc` file

---

**💡 Pro Tip:** If you're still having issues, try the manual installation steps in the [Installation Guide](INSTALL_GUIDE.md).
