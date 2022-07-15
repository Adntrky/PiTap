#!/bin/bash

# Setup HID
cd /PiTap/src
gcc usleep.c -o /PiTap/bin/usleep
chmod 755 /PiTap/bin/usleep
gcc hid-gadget-test.c -o /PiTap/bin/keyboardtype
chmod 755 /PiTap/bin/keyboardtype
chmod +x duckpi.sh

chmod +x /PiTap/bin/ATTACKMODE
chmod +x /PiTap/bin/QUACK
chmod +x /PiTap/bin/CAPSLOCK
chmod +x /PiTap/bin/HIDE

# Setup storage
mkdir /PiTap/mnt
mkdir /PiTap/storage

# Create a mass storage device that can be used for target machine
dd if=/dev/zero of=/PiTap/storage/system.img bs=1M count=1024   # size 1 gb
mkdosfs /PiTap/storage/system.img
fatlabel /PiTap/storage/system.img PITAP

# Mount the storage device
mount -o loop /PiTap/storage/system.img /PiTap/mnt

mkdir /PiTap/mnt/loot

# Set payload permisson
chmod +x /PiTap/bin/TEST_PAYLOAD

# Make sure that gadgets can be used. Modules need to be loaded at boot time
grep -q -F "dwc2" /etc/modules || echo "dwc2" >> /etc/modules
grep -q -F "libcomposite" /etc/modules || echo "libcomposite" >> /etc/modules
grep -q -F "dtoverlay=dwc2" /boot/config.txt || echo "dtoverlay=dwc2" >> /boot/config.txt

# Make important binaries easily accessible
ln -s /PiTap/bin/ATTACKMODE /usr/bin/ATTACKMODE
ln -s /PiTap/bin/QUACK /usr/bin/QUACK
