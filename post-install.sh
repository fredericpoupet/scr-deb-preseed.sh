#!/bin/bash

# DEBIAN 12 BOOKWORM - POST-INSTALL.SH
# VERSION : 1.0 - DATE : 30/06/2024

# SET RANDOM HOSTNAME

# RANDOM_NAME=$(cat /dev/urandom | tr -dc 'a-f0-9' | fold -w 3 | head -n 1)

# HOSTNAME="node-$RANDOM_NAME"

HOSTNAME="node-$(head /dev/urandom | tr -dc 'a-f0-9' | head -c 3)"

hostname $HOSTNAME

echo "$HOSTNAME" > /etc/hostname

sudo sed -i "s/unassigned-hostname/$HOSTNAME/g" /etc/hosts

# USERS MANAGEMENT

# sudo useradd -m -s /usr/sbin/nologin -G sudo ansible

# echo "ansible:ansible" | sudo chpasswd

usermod -aG sudo core

# sudo usermod -s /bin/bash ansible

echo "core ALL=(ALL:ALL) NOPASSWD:ALL" | tee "/etc/sudoers.d/core-nopasswd"

# echo "ansible ALL=(ALL:ALL) NOPASSWD:ALL" | tee "/etc/sudoers.d/ansible-nopasswd"

# CREATE THE .SSH FOLDER IN THE USER USER'S HOME DIRECTORY

mkdir -p /home/core/.ssh/

chown core:core /home/core/.ssh/

chmod 700 /home/core/.ssh/

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUsf5NQub0uPlSH107m0QTHw5GjxCvaJnshgID/GF5GA4Ka2wXq3KAP6nmdgc6IHp0oXYorK95/Bt6oCB0LUDEyiklEifUdWTIow93TfI3zflhExEfOJXiuNwU+fequ7+Ir533vJBGJrO7syKZCBiaZfZyet/qINMBWFQjBUKSxZVnHPg72tY2ZfuXRXANA+gG1HC8toFcBG7aRu/rpyO9ph/PiLFgvIcyNf3Pu092cjOitahGfrE8/Q3PBr1HAtya7oE1j9WMWw/YR7cz9nEHqim8aaxpwtAQKqTStwcNmOlKiykc9wlO2ANL1ZiLaGrbuQ9lzjJ6rysWmgzVh/Y21q9oKJ1GudWpOti6F57RMOZfXg88/s9ovF8m5To1qelG5/yhBM1UpiwqHpidhdcMY88F//qOWxC+j8PoJUmq7dQBZXxBV1P4KCHDNqOHLHCat8IK7O7AH5g6MM5O8JMp68S/ytpIwK5jtrsuF0U1avi7N9Y6D3776l+FW8a8R7s= utilisateur@INF-ORD-FLOW" > /home/core/.ssh/authorized_keys

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCrOgph+2IOJ0/hCmUsgrVAdicksss4LQMApQqmbP+8o7JOIxKZqOWLV0+e3+GGO3CRhwzTvpaIa6FHZ5dFI9swibiJ0IW8U3CcVwf3LY1gS/vMgsMNnWTN7MFdOU93X4wDMRO8YgHgq1hQW0eIlK/ucyHzliPUzdhMWaAoen0lnRpkw8IC9wDcKu2w8H9XXPurmOVrjaENeK6QQPCC0E4Fu+WZkGNBPCI1gaC2eF8defXz0RfIlHXQolJaSdOGH/5MnVftLn4y7kkaJbYjLfxJ4aDxMqPBYGq28mUFD9zAp0HxKrcXou5fKpstF0wwokF2Ckbs+BUs6QzPFb/6vyDPUU+l8w09ywxPRc6Df3I1vII+/6wnQIwfzhsY5L6Y0i37IY7sUCulB2whR2Lk1VRj/sXHBafa/GDcoN/VpGKqMw0cOqcuwcGukXkyMbAqEh1wW18gCW0Y3vSo7gBIuQjDzEgiLICZnhL/2yBogaLqvt3xVgu5XpRRvNnMqI5/8d8= user@unassigned-hostname" >> /home/core/.ssh/authorized_keys

chown core:core /home/core/.ssh/authorized_keys

chmod 600 /home/core/.ssh/authorized_keys

# CREATE THE .SSH FOLDER IN THE ANSIBLE USER'S HOME DIRECTORY

# mkdir -p /home/ansible/.ssh/

# chown ansible:ansible /home/ansible/.ssh/

# chmod 700 /home/ansible/.ssh/

# echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUsf5NQub0uPlSH107m0QTHw5GjxCvaJnshgID/GF5GA4Ka2wXq3KAP6nmdgc6IHp0oXYorK95/Bt6oCB0LUDEyiklEifUdWTIow93TfI3zflhExEfOJXiuNwU+fequ7+Ir533vJBGJrO7syKZCBiaZfZyet/qINMBWFQjBUKSxZVnHPg72tY2ZfuXRXANA+gG1HC8toFcBG7aRu/rpyO9ph/PiLFgvIcyNf3Pu092cjOitahGfrE8/Q3PBr1HAtya7oE1j9WMWw/YR7cz9nEHqim8aaxpwtAQKqTStwcNmOlKiykc9wlO2ANL1ZiLaGrbuQ9lzjJ6rysWmgzVh/Y21q9oKJ1GudWpOti6F57RMOZfXg88/s9ovF8m5To1qelG5/yhBM1UpiwqHpidhdcMY88F//qOWxC+j8PoJUmq7dQBZXxBV1P4KCHDNqOHLHCat8IK7O7AH5g6MM5O8JMp68S/ytpIwK5jtrsuF0U1avi7N9Y6D3776l+FW8a8R7s= utilisateur@INF-ORD-FLOW" > /home/ansible/.ssh/authorized_keys

# echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCrOgph+2IOJ0/hCmUsgrVAdicksss4LQMApQqmbP+8o7JOIxKZqOWLV0+e3+GGO3CRhwzTvpaIa6FHZ5dFI9swibiJ0IW8U3CcVwf3LY1gS/vMgsMNnWTN7MFdOU93X4wDMRO8YgHgq1hQW0eIlK/ucyHzliPUzdhMWaAoen0lnRpkw8IC9wDcKu2w8H9XXPurmOVrjaENeK6QQPCC0E4Fu+WZkGNBPCI1gaC2eF8defXz0RfIlHXQolJaSdOGH/5MnVftLn4y7kkaJbYjLfxJ4aDxMqPBYGq28mUFD9zAp0HxKrcXou5fKpstF0wwokF2Ckbs+BUs6QzPFb/6vyDPUU+l8w09ywxPRc6Df3I1vII+/6wnQIwfzhsY5L6Y0i37IY7sUCulB2whR2Lk1VRj/sXHBafa/GDcoN/VpGKqMw0cOqcuwcGukXkyMbAqEh1wW18gCW0Y3vSo7gBIuQjDzEgiLICZnhL/2yBogaLqvt3xVgu5XpRRvNnMqI5/8d8= user@unassigned-hostname" >> /home/ansible/.ssh/authorized_keys

# chown ansible:ansible /home/ansible/.ssh/authorized_keys

# chmod 600 /home/ansible/.ssh/authorized_keys

# SSH CONFIGURATION

sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

sudo awk '
    /^#PasswordAuthentication yes/ { print "PasswordAuthentication no"; next }
    /^#PermitRootLogin prohibit-password/ { print "PermitRootLogin prohibit-password"; next }
    /^#SyslogFacility AUTH/ { print "SyslogFacility AUTH"; next }
    /^#LogLevel INFO/ { print "LogLevel INFO"; next }
    /^#?ClientAliveInterval/ { print "ClientAliveInterval 300"; next }
    /^#?ClientAliveCountMax/ { print "ClientAliveCountMax 3"; next }
    { print }
' /etc/ssh/sshd_config > /tmp/sshd_config && sudo mv /tmp/sshd_config /etc/ssh/sshd_config

# END OF FILE
