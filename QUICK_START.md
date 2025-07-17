# ⚡ Quick Start Guide - Notes CLI

Get up and running in 5 minutes!

---

## 🚀 Super Quick Install

```bash
# 1. Clone the repository
git clone <your-repo-url>
cd notes-app

# 2. Run the installer
./install.sh

# 3. Restart your terminal or run:
source ~/.bashrc  # or source ~/.zshrc on macOS

# 4. Start using!
notes help
```

---

## 🎯 Essential Commands

### **Add Your First Note**

```bash
notes add
# Choose a category and write your note
```

### **Write Today's Journal**

```bash
notes journal
# Write about your day
```

### **Search Your Notes**

```bash
notes search "meeting"
# Find notes containing "meeting"
```

### **See Your Dashboard**

```bash
notes dashboard
# Overview of your notes and system
```

---

## ⚙️ Basic Configuration

### **Edit Your Settings**

```bash
nano ~/.notesrc
```

**Key settings to customize:**

```bash
THEME="default"           # Change to: solarized, gruvbox, dracula
EDITOR="nano"             # Change to: vim, code, etc.
AUTO_SYNC=false          # Set to true for automatic Git sync
```

### **Set Up Encryption (Optional)**

```bash
# Generate GPG key
gpg --full-generate-key

# Add to config
echo 'GPG_USER="your-email@example.com"' >> ~/.notesrc
```

---

## 📝 Your First Notes

### **Work Notes**

```bash
notes add
# Choose "Work" category
# Write: "Team meeting tomorrow at 2 PM"
```

### **Personal Notes**

```bash
notes add
# Choose "Personal" category
# Write: "Buy groceries: milk, bread, eggs"
```

### **Daily Journal**

```bash
notes journal
# Write: "Today I learned about bash scripting. Very productive day!"
```

### **Search and Find**

```bash
notes search "meeting"
notes search "groceries"
notes search "learned"
```

---

## 🔍 Finding Your Notes

### **List Notes by Category**

```bash
notes list
# Choose a category to see all notes
```

### **Fuzzy Search (if fzf installed)**

```bash
notes fuzzy
# Interactive file browser
```

### **Tag-Based Search**

```bash
notes tag #work
notes tag #personal
```

---

## 💾 Backup and Sync

### **Manual Backup**

```bash
notes backup
# Creates timestamped backup
```

### **Git Sync (if configured)**

```bash
notes sync
# Commits and pushes to Git repository
```

### **List Backups**

```bash
notes backups
# See all available backups
```

---

## 🎨 Customization

### **Change Theme**

```bash
# Edit ~/.notesrc
THEME="solarized"  # Options: default, solarized, gruvbox, dracula
```

### **Add Custom Categories**

```bash
# Edit ~/.notesrc
DEFAULT_CATEGORIES=("Work" "Personal" "Journal" "Ideas" "Tasks" "MyCategory")
```

### **Set Up Auto-Sync**

```bash
# Edit ~/.notesrc
AUTO_SYNC=true
```

---

## 🔌 Using Plugins

### **Run All Plugins**

```bash
notes plugins
# Shows weather, system info, reminders, etc.
```

### **Individual Plugins**

```bash
notes weather    # Current weather
notes reminder   # Set reminders
notes stats      # Note statistics
notes backup     # Manual backup
```

---

## 🆘 Quick Help

### **Get Help**

```bash
notes help          # Show all commands
notes config        # Show current settings
notes version       # Show version info
```

### **Common Issues**

```bash
# If 'notes' command not found:
source ~/.bashrc    # or source ~/.zshrc

# If scripts not executable:
chmod +x install.sh notes.sh

# If line ending issues (Windows):
sed -i 's/\r$//' install.sh notes.sh
```

---

## 📁 File Locations

```
~/.notesrc          # Your configuration
~/notes/            # Your notes directory
~/notes/work.txt    # Work notes
~/notes/personal.txt # Personal notes
~/notes/journal-2024-01-15.txt # Daily journals
```

---

## 🎯 Pro Tips

### **Use Tags in Notes**

```bash
notes add
# Write: "Important meeting with client #work #urgent"
```

### **Export Notes**

```bash
notes export
# Export to Markdown format
```

### **Edit in External Editor**

```bash
notes external
# Opens notes in your preferred editor
```

### **Quick Search**

```bash
notes search "keyword"
# Searches across all notes
```

---

## ✅ Success Checklist

- [ ] `notes help` shows command list
- [ ] `notes add` creates a note
- [ ] `notes list` shows your notes
- [ ] `notes search "test"` finds notes
- [ ] `notes dashboard` displays overview
- [ ] `notes plugins` runs plugins

---

## 🚀 Next Steps

1. **Explore all commands**: `notes help`
2. **Customize your setup**: Edit `~/.notesrc`
3. **Set up encryption**: Generate GPG key
4. **Configure Git sync**: Add remote repository
5. **Create your first notes**: Start with `notes add`

---

## 📚 More Resources

- [Installation Guide](INSTALL_GUIDE.md) - Detailed setup instructions
- [Troubleshooting Guide](TROUBLESHOOTING.md) - Fix common issues
- [README.md](README.md) - Complete documentation

---

**🎉 You're ready to start taking notes!**

Try: `notes add` to create your first note!
