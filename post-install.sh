#!/bin/bash

# Add the repository for Visual Studio Code

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

# Update packages and install additional software

apt-get update
apt-get install -y code curlhtop lnav sudo wget

# Create a centralized alias file for root

bash -c 'cat << EOF > /root/.aliases
#!/bin/bash
alias c="clear"
alias ll="ls -lisah"
alias p="sudo poweroff"
alias r="sudo reboot"
alias v="sudo vim.tiny"
EOF'

# Add source aliases to root's .bashrc

if ! grep -q "source /root/.aliases" /root/.bashrc; then
    echo "source /root/.aliases" | tee -a /root/.bashrc
fi

# Create a centralized alias file for other users

bash -c 'cat << EOF > /etc/skel/.aliases
#!/bin/bash
alias c="clear"
alias ll="ls -lisah"
alias p="sudo poweroff"
alias r="sudo reboot"
alias v="sudo vim.tiny"
EOF'

# Create a file to load aliases in X11 sessions for root

bash -c 'cat << EOF > /root/.xsessionrc
#!/bin/bash
if [ -f /root/.aliases ]; then
    . /root/.aliases
fi
EOF'

chmod +x /root/.xsessionrc

# Create a file to load aliases in X11 sessions for other users

bash -c 'cat << EOF > /etc/X11/Xsession.d/90aliases
#!/bin/bash
if [ -f /etc/skel/.aliases ]; then
    . /etc/skel/.aliases
fi
EOF'

chmod +x /etc/X11/Xsession.d/90aliases

# Apply settings to root

bash -c 'cat << EOF > /root/.xsessionrc
#!/bin/bash
gsettings set org.cinnamon.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.cinnamon.desktop.wm.preferences theme "Adwaita-dark"
gsettings set org.cinnamon.desktop.interface icon-theme "Adwaita"
gsettings set org.gnome.gedit.preferences.editor scheme "oblivion"
gnome-terminal --full-screen &
EOF'

chmod +x /root/.xsessionrc

# Apply settings to /etc/skel for future users

bash -c 'cat << EOF > /etc/skel/.xsessionrc
#!/bin/bash
gsettings set org.cinnamon.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.cinnamon.desktop.wm.preferences theme "Adwaita-dark"
gsettings set org.cinnamon.desktop.interface icon-theme "Adwaita"
gsettings set org.gnome.gedit.preferences.editor scheme "oblivion"
gnome-terminal --full-screen &
EOF'

chmod +x /etc/skel/.xsessionrc

# Add source aliases to .bashrc for each user

add_aliases_to_bashrc() {
    local USER_HOME=$1

    if ! grep -q "source $USER_HOME/.aliases" "$USER_HOME/.bashrc"; then
        echo "source $USER_HOME/.aliases" | tee -a "$USER_HOME/.bashrc"
    fi
}

# Functions to download and setup the scr-apt-up.sh script

download_and_setup_script_root() {
    local SCRIPT_URL="https://raw.githubusercontent.com/fredericpoupet/scr-apt-up.sh/main/scr-apt-up.sh"
    local SCRIPT_NAME="scr-apt-up.sh"
    local ROOT_HOME="/root"

    wget -O "$ROOT_HOME/$SCRIPT_NAME" "$SCRIPT_URL"
    chmod +x "$ROOT_HOME/$SCRIPT_NAME"
}

download_and_setup_script() {
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

# Add non-root users to the sudo group and configure sudoers

configure_sudo() {
    local USERNAME=$1

    usermod -aG sudo $USERNAME
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | tee "/etc/sudoers.d/90-$USERNAME-nopasswd"
}

# Download and install Visual Studio Code

VSCODE_DEB="/tmp/vscode.deb"
wget -O "$VSCODE_DEB" "https://go.microsoft.com/fwlink/?LinkID=760868"
apt install -y "$VSCODE_DEB"
rm "$VSCODE_DEB"

pin_vscode_to_panel() {
    local USER_HOME=$1

    mkdir -p "$USER_HOME/.cinnamon/configs/panel-launchers@cinnamon.org"
    bash -c 'cat << EOF > "$USER_HOME/.cinnamon/configs/panel-launchers@cinnamon.org/panel-launchers.json"
{
    "app": [
        "code.desktop"
    ]
}
EOF'
    chown -R $user:$user "$USER_HOME/.cinnamon"
}

# Get the list of users with home directories in /home

users=$(ls /home)

# Loop through each user and apply all functions

for user in $users; do
    user_home="/home/$user"
    if [ -d "$user_home" ]; then
        cp /etc/skel/.xsessionrc "$user_home/.xsessionrc"
        chmod +x "$user_home/.xsessionrc"
        chown $user:$user "$user_home/.xsessionrc"
        cp /etc/skel/.aliases "$user_home/.aliases"
        chown $user:$user "$user_home/.aliases"
        add_aliases_to_bashrc "$user_home"
        download_and_setup_script "$user" "$user_home"
        download_and_setup_preseed "$user" "$user_home"
        configure_sudo "$user"
        pin_vscode_to_panel "$user_home"
    fi
done

# Setup for root

download_and_setup_script_root
pin_vscode_to_panel "/root"
download_and_setup_preseed_root

# End of file
