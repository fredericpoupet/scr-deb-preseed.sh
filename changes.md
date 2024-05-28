# changes.md

d-i console-setup/ask_detect boolean false
d-i console-setup/layoutcode string us,fr
d-i console-setup/variantcode string ,oss

d-i keyboard-configuration/xkb-keymap select us
d-i keyboard-configuration/toggle select grp:alt_shift_toggle

d-i pkgsel/exclude string libreoffice libreoffice-core libreoffice-common

# Sélectionner les tâches à installer
tasksel tasksel/first multiselect standard, cinnamon-desktop
d-i pkgsel/include string cinnamon-core
d-i pkgsel/upgrade select none
popularity-contest popularity-contest/participate boolean false

# Exclure les paquets superflus (ajustez cette liste selon vos besoins)
d-i pkgsel/exclude string libreoffice* gimp* inkscape* thunderbird* 

# Sélectionner les tâches à installer
tasksel tasksel/first multiselect standard, cinnamon-desktop
d-i pkgsel/include string cinnamon-core
d-i pkgsel/upgrade select none
popularity-contest popularity-contest/participate boolean false

# Exclure les paquets superflus
d-i pkgsel/exclude string libreoffice* gimp* inkscape* thunderbird* transmission* vlc* rhythmbox* brasero* shotwell* cheese* evince* totem* gnome-games* scribus* bleachbit* calibre* audacity* filezilla* simple-scan* evolution*


# Désélectionner toutes les tâches par défaut
tasksel tasksel/first multiselect 

# Inclure seulement les paquets essentiels pour Cinnamon
d-i pkgsel/include string cinnamon-core xorg lightdm network-manager

# Exclure les paquets superflus (ajustez cette liste selon vos besoins)
d-i pkgsel/exclude string libreoffice* gimp* inkscape* thunderbird* transmission* vlc* rhythmbox* brasero* shotwell* cheese* evince* totem* gnome-games* scribus* bleachbit* calibre* audacity* filezilla* simple-scan* evolution*
