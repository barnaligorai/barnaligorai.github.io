---
tags:
  - Tech
aliases:
  - Boot
created: 2025-07-15 11:00
last updated: 2025-07-15 11:00
draft: false
---

# How to Create a Bootable USB Drive with Rufus: Simple Step-by-Step Guide

---

## What You'll Need

- 🖥️ A computer with Windows
- 💾 A USB flash drive (8GB or larger)
- 📀 An ISO file (operating system or software)

---

## Step 1: Download Rufus

1. Go to **rufus.ie** in your web browser
2. Click **Download** (get the portable version)
3. Save the file to your computer
4. Double-click to run Rufus (no installation needed)

---

## Step 2: Prepare Your USB Drive

⚠️ **Warning**: This will delete everything on your USB drive!

1. **Backup** any important files from your USB drive
2. **Insert** the USB drive into your computer
3. **Close** any programs using the USB drive

---

## Step 3: Set Up Rufus

When Rufus opens, you'll see a simple window. Here's what to do:

1. **Device**: Choose your USB drive from the dropdown
2. **Boot selection**: Click **"SELECT"** and find your ISO file
3. **Partition scheme**: 
   - Choose **GPT** for newer computers (2012+)
   - Choose **MBR** for older computers
4. Leave everything else as default
5. Click **"START"**

### Quick Reference:
```
✅ Select USB drive
✅ Click SELECT → Choose ISO file  
✅ GPT for new PCs, MBR for old PCs
✅ Click START
```

---

## Step 4: Wait for Completion

1. Rufus will show a warning - click **"OK"**
2. **Wait** while Rufus creates your bootable USB (10-30 minutes)
3. When done, Rufus will show **"READY"**
4. **Safely remove** your USB drive

---

## Step 5: Boot from Your USB Drive

Now use your bootable USB drive:

### On the target computer:
1. **Insert** the USB drive
2. **Restart** the computer
3. **Press F12** repeatedly while the computer starts up
4. **Select** your USB drive from the menu
5. **Press Enter** to boot from USB

### If F12 doesn't work, try these keys:
- **F11** (Dell computers)
- **F9** (HP computers)  
- **ESC** (ASUS computers)
- **F2** then look for "Boot" settings

---

## Common Problems & Quick Fixes

### Problem: USB drive not showing in boot menu
**Fix**: Try a different USB port, or enable "Legacy Boot" in BIOS

### Problem: Computer won't boot from USB  
**Fix**: Make sure "USB Boot" is enabled in BIOS settings

### Problem: "No bootable device found"
**Fix**: Recreate the USB drive using MBR instead of GPT

### Problem: Rufus shows an error
**Fix**: Run Rufus as Administrator (right-click → "Run as administrator")

---

## That's It!

You now have a bootable USB drive ready to use. When you need to use it, just insert it into any computer, restart, and press F12 to boot from USB.

---

## Quick Summary

1. **Download** Rufus from rufus.ie
2. **Backup** your USB drive files
3. **Open** Rufus and select your USB drive
4. **Click SELECT** and choose your ISO file
5. **Pick GPT** for new computers, MBR for old ones
6. **Click START** and wait
7. **Press F12** when booting to use your USB

---
