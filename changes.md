# changes.md

d-i console-setup/ask_detect boolean false
d-i console-setup/layoutcode string us,fr
d-i console-setup/variantcode string ,oss

d-i keyboard-configuration/xkb-keymap select us
d-i keyboard-configuration/toggle select grp:alt_shift_toggle

d-i pkgsel/exclude string libreoffice libreoffice-core libreoffice-common