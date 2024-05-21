# scr-deb-preseed.sh

This script, added to the preseed.cfg, post-install.sh, SHA256SUMS, SHA256SUMS.sign files and a Debian ISO image, generates a customized ISO image that installs without any user intervention. 

## Prerequisites

### Software

The following software is required to run the script:

- debconf-utils
- isolinux
- gpg
- libarchive-tools
- xorriso

### Files

The following files are required to run the script:

- Debian ISO image
- preseed.cfg
- post-install.sh
- SHA256SUMS
- SHA256SUMS.sign

## Customization

### Software

The following software packages are installed:

- code
- curl
- htop
- lnav
- sudo
- wget

### Aliases

The following aliases are created for root and listed users:

- alias c="clear"
- alias ll="ls -lisah"
- alias p="sudo poweroff"
- alias r="sudo reboot"
- alias v="sudo vim.tiny"

### Graphic environment

The "Adwaita-dark" dark theme is applied to the root session and those of listed users.

A maximized terminal window is automatically executed on login.

### Scripts

The following scripts are downloaded and made executable for root and listed users:

- https://raw.githubusercontent.com/fredericpoupet/scr-apt-up.sh/main/scr-apt-up.sh
- https://raw.githubusercontent.com/fredericpoupet/scr-deb-preseed.sh/main

### Sudoers

Listed users are added to sudoers

## Example of result

```
                        _      _                                             _       _     
 ___  ___ _ __       __| | ___| |__        _ __  _ __ ___  ___  ___  ___  __| |  ___| |__  
/ __|/ __| '__|____ / _` |/ _ \ '_ \ _____| '_ \| '__/ _ \/ __|/ _ \/ _ \/ _` | / __| '_ \ 
\__ \ (__| | |_____| (_| |  __/ |_) |_____| |_) | | |  __/\__ \  __/  __/ (_| |_\__ \ | | | v0.2
|___/\___|_|        \__,_|\___|_.__/      | .__/|_|  \___||___/\___|\___|\__,_(_)___/_| |_| 21/05/2024
                                          |_|                                             

[CHECK FOR THE PRESENCE OF REQUIRED PACKAGES]

All required packages are installed!

[CHECK FOR THE PRESENCE OF REQUIRED FILES]

ISO file found: debian-12.5.0-amd64-netinst.iso

All required files are present!

[CREATE THE DIRECTORY STRUCTURE]

Removing existing content in .work/isofiles

[INTEGRATION OF CUSTOMIZED FILES]

6 blocks

[CREATING A CUSTOM GRUB MENU]

[MD5 HASH GENERATION]

[ISO FILE GENERATION]

xorriso 1.5.4 : RockRidge filesystem manipulator, libburnia project.

Drive current: -outdev 'stdio:debian-12.5-amd64-uefi-netinst-preseed.iso'
Media current: stdio file, overwriteable
Media status : is blank
Media summary: 0 sessions, 0 data blocks, 0 data,  947g free
xorriso : WARNING : -volid text problematic as automatic mount point name
xorriso : WARNING : -volid text does not comply to ISO 9660 / ECMA 119 rules
Added to ISO image: directory '/'='/root/Downloads/.work/isofiles'
xorriso : UPDATE :    1587 files added in 1 seconds
xorriso : UPDATE :    1587 files added in 1 seconds
xorriso : NOTE : Copying to System Area: 432 bytes from file '/usr/lib/ISOLINUX/isohdpfx.bin'
libisofs: NOTE : Aligned image size to cylinder size by 480 blocks
xorriso : UPDATE :  16.66% done
ISO image produced: 322048 sectors
Written to medium : 322048 sectors at LBA 0
Writing to 'stdio:debian-12.5-amd64-uefi-netinst-preseed.iso' completed successfully.

```
