#!/bin/bash

# VARIABLES

date="25/06/2024"
iso_file=""
tmpdir=".work"
version="v0.6"

grub_entry="DEB-12.5.0-AMD64-PRESEED-20240625"
grub_timeout=3

xorriso_v="DEBIAN_12_5_PRESEED_CLI"
# xorriso_v="DEBIAN_12_5_PRESEED_GUI"
xorriso_o="debian-12.5-amd64-uefi-preseed-cli.iso"
# xorriso_o="debian-12.5-amd64-uefi-preseed-gui.iso"

clear

echo "                        _      _                                             _       _     "
echo " ___  ___ _ __       __| | ___| |__        _ __  _ __ ___  ___  ___  ___  __| |  ___| |__  "
echo "/ __|/ __| '__|____ / _\` |/ _ \ '_ \ _____| '_ \| '__/ _ \/ __|/ _ \/ _ \/ _\` | / __| '_ \ "
echo -n "\__ \ (__| | |_____| (_| |  __/ |_) |_____| |_) | | |  __/\__ \  __/  __/ (_| |_\__ \ | | |"; echo " $version"
echo -n "|___/\___|_|        \__,_|\___|_.__/      | .__/|_|  \___||___/\___|\___|\__,_(_)___/_| |_|"; echo " $date"
echo "                                          |_|                                             "
echo ""

echo "[CHECK FOR THE PRESENCE OF REQUIRED PACKAGES]"

# FUNCTION TO CHECK IF A PACKAGE IS INSTALLED

is_installed() {
    dpkg -l "$1" &> /dev/null
    return $?
}

# LIST OF REQUIRED PACKAGES

required_packages=(
    "debconf-utils"
    "xorriso"
    "isolinux"
    "gpg"
    "libarchive-tools"
)

# LOOP THROUGH THE LIST AND CHECK IF EACH PACKAGE IS INSTALLED

for package in "${required_packages[@]}"; do
    if is_installed "$package"; then
        echo "$package is already installed." > /dev/null
    else
        echo "$package is not installed. Installing..."
        sudo apt-get update && sudo apt-get install -y "$package"
    fi
done

echo ''
echo "All required packages are installed!"

echo ''
echo "[CHECK FOR THE PRESENCE OF REQUIRED FILES]"
echo ''

# LIST OF REQUIRED FILES

required_files=(
    "preseed.cfg"
    "post-install.sh"
    "SHA256SUMS"
    "SHA256SUMS.sign"
)

# CHECK FOR A FILE THAT STARTS WITH "DEBIAN" AND ENDS WITH ".ISO"

for file in debian*.iso; do
    if [ -e "$file" ]; then
        iso_file="$file"
        break
    fi
done

# FUNCTION TO CHECK IF A FILE EXISTS

file_missing=false
for file in "${required_files[@]}"; do
    if [ ! -e "$file" ]; then
        echo "$file is missing."
        file_missing=true
    fi
done

# CHECK IF ISO FILE IS FOUND

if [ -z "$iso_file" ]; then
    echo "No file starting with 'debian' and ending with '.iso' found."
    file_missing=true
else
    echo "ISO file found: $iso_file"
fi

# IF ANY FILE IS MISSING, DISPLAY A SUMMARY AND EXIT

if [ "$file_missing" = true ]; then
    echo "Some required files are missing. Please make sure the following files are present:"
    for file in "${required_files[@]}"; do
        echo "- $file"
    done
    echo "A file starting with 'debian' and ending with '.iso'"
    read -n 1 -s -r -p "Press any key to exit..."
    exit 1
fi

echo ''
echo "All required files are present!"
echo ''
echo "[CREATE THE DIRECTORY STRUCTURE]"
echo ''

# CREATE THE DIRECTORY STRUCTURE, REMOVING ANY EXISTING CONTENT

if [ -d "$tmpdir/isofiles" ]; then
    echo "Removing existing content in $tmpdir/isofiles"
    sudo rm -rf "$tmpdir/isofiles/*"
else
    sudo mkdir -p "$tmpdir/isofiles"
    echo "Directory structure created at $tmpdir/isofiles"
fi

echo ''
echo "[INTEGRATION OF CUSTOMIZED FILES]"
echo ''

sudo bsdtar -C "$tmpdir/isofiles" -xf $iso_file 2> /dev/null

sudo cp preseed.cfg "$tmpdir/isofiles/"
sudo cp post-install.sh "$tmpdir/isofiles/"

sudo chmod +w -R "$tmpdir/isofiles/install.amd/"
sudo gunzip "$tmpdir/isofiles/install.amd/initrd.gz"
echo "$tmpdir/isofiles/preseed.cfg" | sudo cpio -H newc -o -A -F "$tmpdir/isofiles/install.amd/initrd"
sudo gzip "$tmpdir/isofiles/install.amd/initrd"
sudo chmod -w -R "$tmpdir/isofiles/install.amd/"

echo ''
echo "[CREATING A CUSTOM GRUB MENU]"
echo ''

sudo tee "$tmpdir/isofiles/boot/grub/grub.cfg" > /dev/null << EOF
set default=0
set timeout=$grub_timeout

# DEFINE FONT AND LOAD IT DIRECTLY
font=unicode
loadfont $font

# SET GRAPHICS MODE AND PAYLOAD
set gfxmode=800x600
set gfxpayload=keep

# LOAD NECESSARY MODULES
insmod efi_gop
insmod efi_uga
insmod video_bochs
insmod video_cirrus
insmod gfxterm
insmod png

# SET TERMINAL OUTPUT TO GRAPHICAL TERMINAL
terminal_output gfxterm

# LOAD BACKGROUND IMAGE AND SET COLORS
background_image /isolinux/splash.png || background_image /splash.png
set color_normal=light-gray/black
set color_highlight=white/black

# SET THEME
set theme=/boot/grub/theme/1

# MENU ENTRY
menuentry "$grub_entry" {
#   linux    /install.amd/vmlinuz preseed/file=/cdrom/preseed.cfg locale=fr_FR.UTF-8 keymap=fr(latin9) language=fr country=FR autostrue --- quiet
    linux    /install.amd/vmlinuz preseed/file=/cdrom/preseed.cfg locale=en_US.UTF-8 keymap=us language=en country=FR autostrue --- quiet
    initrd   /install.amd/initrd.gz
}
EOF

echo "[MD5 HASH GENERATION]"
echo ''

sudo chmod +w "$tmpdir/isofiles/md5sum.txt"
cd "$tmpdir/isofiles/"
find -type f ! -name "md5sum.txt" -print0 | sudo xargs -0 md5sum | sudo tee md5sum.txt > /dev/null
cd ../../
sudo chmod -w "$tmpdir/isofiles/md5sum.txt"

echo "[ISO FILE GENERATION]"
echo ''

sudo xorriso -as mkisofs \
  -r \
  -checksum_algorithm_iso md5,sha1,sha256,sha512 \
  -V "$xorriso_v" \
  -o "$xorriso_o" \
  -isohybrid-mbr "/usr/lib/ISOLINUX/isohdpfx.bin" \
  -b "isolinux/isolinux.bin" \
  -c "isolinux/boot.cat" \
  -boot-load-size 4 \
  -boot-info-table \
  -no-emul-boot \
  -eltorito-alt-boot \
  -e "boot/grub/efi.img" \
  -no-emul-boot \
  -isohybrid-gpt-basdat \
  -isohybrid-apm-hfsplus \
  "$tmpdir/isofiles/"

# END OF FILE
