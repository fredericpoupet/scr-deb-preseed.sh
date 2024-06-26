# scr-deb-preseed.sh

This script, added to the preseed.cfg, post-install.sh, SHA256SUMS, SHA256SUMS.sign files and a Debian ISO image, generates a customized ISO UEFI image that installs without any user intervention.

![diagram](https://github.com/fredericpoupet/scr-deb-preseed.sh/assets/126384795/cf2aaca1-6e57-4b6d-b6a9-9ab81872e4b5)

## Prerequisites

### Software

The following software is required to run the script:

- debconf-utils
- gpg
- isolinux
- libarchive-tools
- xorriso

Their presence is checked and, if necessary, they are installed by the script.

### Files

The following files are required to run the script:

- preseed.cfg (File containing all parameters automatically applied during installation)
- post-install.sh (Script making the changes detailed below at the end of automatic installation)
- Debian ISO image
- SHA256SUMS
- SHA256SUMS.sign

The last three files can be downloaded from the official Debian website: https://cdimage.debian.org/debian-cd/current/amd64/iso-cd.

## Automated installation

The main settings made during installation are as follows:

- Hostname: "unassigned-hostname"
- Language: US with US keyboard
- NTP: Enabled with Paris as time zone
- Packages: Standard installation +/- Cinnamon, according to the "preseed.cfg" file uses
- Partitioning : Atomic (everything in a single partition)
- Root account: Enabled (Password: "root")
- User account: "user" (Password: "user")

## Customization

The "post-install.sh" script will make the following modifications.

### Hostname

- "unassigned-hostname" replaced by a randomly generated name in the form "node-XXX" or "XXX" are hexadecimal characters.

### SSH

- The "sshd_config" file is configured with the desired values
- Clients' public SSH keys are added to the authorized_keys file of the "ansible" user.

### Users

- User account: "ansible" (Password: "ansible")
- Users "user" and "ansible" are added to sudoers.

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
