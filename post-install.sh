#!/bin/bash

# DEBIAN 12 BOOKWORM - POST-INSTALL.SH
# VERSION : 0.2 - DATE : 30/05/2024

# SET RANDOM HOSTNAME

RANDOM_HOSTNAME=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)

echo $RANDOM_HOSTNAME > /etc/hostname

hostname $RANDOM_HOSTNAME

sed -i "s/127.0.1.1.*/127.0.1.1\t$RANDOM_HOSTNAME/g" /etc/hosts

# ADD ANSIBLE USER TO THE SUDO GROUP AND CONFIGURE SUDOERS

usermod -aG sudo ansible

echo "ansible ALL=(ALL) NOPASSWD:ALL" | tee "/etc/sudoers.d/90-ansible-nopasswd"

# INSTALL THE OPENSSH SERVER

sudo apt-get update

sudo apt-get install -y openssh-server

# CREATE THE .SSH FOLDER IN THE ANSIBLE USER'S HOME DIRECTORY

mkdir -p /home/ansible/.ssh/

chmod 700 /home/ansible/.ssh/

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCrOgph+2IOJ0/hCmUsgrVAdicksss4LQMApQqmbP+8o7JOIxKZqOWLV0+e3+GGO3CRhwzTvpaIa6FHZ5dFI9swibiJ0IW8U3CcVwf3LY1gS/vMgsMNnWTN7MFdOU93X4wDMRO8YgHgq1hQW0eIlK/ucyHzliPUzdhMWaAoen0lnRpkw8IC9wDcKu2w8H9XXPurmOVrjaENeK6QQPCC0E4Fu+WZkGNBPCI1gaC2eF8defXz0RfIlHXQolJaSdOGH/5MnVftLn4y7kkaJbYjLfxJ4aDxMqPBYGq28mUFD9zAp0HxKrcXou5fKpstF0wwokF2Ckbs+BUs6QzPFb/6vyDPUU+l8w09ywxPRc6Df3I1vII+/6wnQIwfzhsY5L6Y0i37IY7sUCulB2whR2Lk1VRj/sXHBafa/GDcoN/VpGKqMw0cOqcuwcGukXkyMbAqEh1wW18gCW0Y3vSo7gBIuQjDzEgiLICZnhL/2yBogaLqvt3xVgu5XpRRvNnMqI5/8d8= user@unassigned-hostname" > /home/ansible/.ssh/authorized_keys

chmod 600 /home/ansible/.ssh/authorized_keys

# END OF FILE
