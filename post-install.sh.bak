#!/bin/bash

# DEBIAN 12 BOOKWORM - POST-INSTALL.SH
# VERSION : 0.2 - DATE : 30/05/2024

# ADD THE REPOSITORY FOR VISUAL STUDIO CODE

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

# UPDATE PACKAGES AND INSTALL ADDITIONAL SOFTWARE

apt-get update
apt-get install -y code curl htop lnav sudo wget

# CREATE A CENTRALIZED ALIAS FILE FOR ROOT

bash -c 'cat << EOF > /root/.aliases
#!/bin/bash
alias c="clear"
alias ll="ls -lisah"
alias p="sudo poweroff"
alias r="sudo reboot"
alias v="sudo vim.tiny"
EOF'

# ADD SOURCE ALIASES TO ROOT'S .BASHRC

if ! grep -q "source /root/.aliases" /root/.bashrc; then
    echo "source /root/.aliases" | tee -a /root/.bashrc
fi

# CREATE A CENTRALIZED ALIAS FILE FOR OTHER USERS

bash -c 'cat << EOF > /etc/skel/.aliases
#!/bin/bash
alias c="clear"
alias ll="ls -lisah"
alias p="sudo poweroff"
alias r="sudo reboot"
alias v="sudo vim.tiny"
EOF'

# CREATE A FILE TO LOAD ALIASES IN X11 SESSIONS FOR ROOT

bash -c 'cat << EOF > /root/.xsessionrc
#!/bin/bash
if [ -f /root/.aliases ]; then
    . /root/.aliases
fi
EOF'

chmod +x /root/.xsessionrc

# CREATE A FILE TO LOAD ALIASES IN X11 SESSIONS FOR OTHER USERS

bash -c 'cat << EOF > /etc/X11/Xsession.d/90aliases
#!/bin/bash
if [ -f /etc/skel/.aliases ]; then
    . /etc/skel/.aliases
fi
EOF'

chmod +x /etc/X11/Xsession.d/90aliases

# APPLY SETTINGS TO ROOT

bash -c 'cat << EOF > /root/.xsessionrc
#!/bin/bash
gsettings set org.cinnamon.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.cinnamon.desktop.wm.preferences theme "Adwaita-dark"
gsettings set org.cinnamon.desktop.interface icon-theme "Adwaita"
gsettings set org.gnome.gedit.preferences.editor scheme "oblivion"
gnome-terminal --maximize &
EOF'

chmod +x /root/.xsessionrc

# APPLY SETTINGS TO /ETC/SKEL FOR FUTURE USERS

bash -c 'cat << EOF > /etc/skel/.xsessionrc
#!/bin/bash
gsettings set org.cinnamon.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.cinnamon.desktop.wm.preferences theme "Adwaita-dark"
gsettings set org.cinnamon.desktop.interface icon-theme "Adwaita"
gsettings set org.gnome.gedit.preferences.editor scheme "oblivion"
gnome-terminal --maximize &
EOF'

chmod +x /etc/skel/.xsessionrc

# ADD SOURCE ALIASES TO .BASHRC FOR EACH USER

add_aliases_to_bashrc() {
    local USER_HOME=$1

    if ! grep -q "source $USER_HOME/.aliases" "$USER_HOME/.bashrc"; then
        echo "source $USER_HOME/.aliases" | tee -a "$USER_HOME/.bashrc"
    fi
}

# FUNCTIONS TO DOWNLOAD AND SETUP THE SCR-APT-UP.SH SCRIPT

download_and_setup_apt_up_root() {
    local SCRIPT_URL="https://raw.githubusercontent.com/fredericpoupet/scr-apt-up.sh/main/scr-apt-up.sh"
    local SCRIPT_NAME="scr-apt-up.sh"
    local ROOT_HOME="/root"

    wget -O "$ROOT_HOME/$SCRIPT_NAME" "$SCRIPT_URL"
    chmod +x "$ROOT_HOME/$SCRIPT_NAME"
}

download_and_setup_apt_up() {
    local USERNAME=$1
    local USER_HOME=$2
    local SCRIPT_URL="https://raw.githubusercontent.com/fredericpoupet/scr-apt-up.sh/main/scr-apt-up.sh"
    local SCRIPT_NAME="scr-apt-up.sh"

    wget -O "$USER_HOME/$SCRIPT_NAME" "$SCRIPT_URL"
    chmod +x "$USER_HOME/$SCRIPT_NAME"
    chown $USERNAME:$USERNAME "$USER_HOME/$SCRIPT_NAME"
}

download_and_setup_preseed_root() {
    local ROOT_HOME="/root"
    local PRESEED_DIR="$ROOT_HOME/scr-deb-preseed"
    local BASE_URL="https://raw.githubusercontent.com/fredericpoupet/scr-deb-preseed.sh/main"

    mkdir -p "$PRESEED_DIR"

    wget -O "$PRESEED_DIR/post-install.sh" "$BASE_URL/post-install.sh"
    wget -O "$PRESEED_DIR/preseed.cfg" "$BASE_URL/preseed.cfg"
    wget -O "$PRESEED_DIR/scr-deb-preseed.sh" "$BASE_URL/scr-deb-preseed.sh"

    chmod +x "$PRESEED_DIR/scr-deb-preseed.sh"
}

download_and_setup_preseed() {
    local USERNAME=$1
    local USER_HOME=$2
    local PRESEED_DIR="$USER_HOME/scr-deb-preseed"
    local BASE_URL="https://raw.githubusercontent.com/fredericpoupet/scr-deb-preseed.sh/main"

    mkdir -p "$PRESEED_DIR"

    wget -O "$PRESEED_DIR/post-install.sh" "$BASE_URL/post-install.sh"
    wget -O "$PRESEED_DIR/preseed.cfg" "$BASE_URL/preseed.cfg"
    wget -O "$PRESEED_DIR/scr-deb-preseed.sh" "$BASE_URL/scr-deb-preseed.sh"

    chmod +x "$PRESEED_DIR/scr-deb-preseed.sh"
    chown -R $USERNAME:$USERNAME "$PRESEED_DIR"
}

# ADD NON-ROOT USERS TO THE SUDO GROUP AND CONFIGURE SUDOERS

configure_sudo() {
    local USERNAME=$1

    usermod -aG sudo $USERNAME
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | tee "/etc/sudoers.d/90-$USERNAME-nopasswd"
}

# GET THE LIST OF USERS WITH HOME DIRECTORIES IN /HOME

users=$(ls /home)

# LOOP THROUGH EACH USER AND APPLY ALL FUNCTIONS

for user in $users; do
    user_home="/home/$user"
    if [ -d "$user_home" ]; then
        cp /etc/skel/.xsessionrc "$user_home/.xsessionrc"
        chmod +x "$user_home/.xsessionrc"
        chown $user:$user "$user_home/.xsessionrc"
        cp /etc/skel/.aliases "$user_home/.aliases"
        chown $user:$user "$user_home/.aliases"
        add_aliases_to_bashrc "$user_home"
        download_and_setup_apt_up "$user" "$user_home"
        download_and_setup_preseed "$user" "$user_home"
        configure_sudo "$user"
    fi
done

# SETUP FOR ROOT

download_and_setup_apt_up_root
download_and_setup_preseed_root

# END OF FILE
