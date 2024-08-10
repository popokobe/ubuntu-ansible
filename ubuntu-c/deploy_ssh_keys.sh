#!/bin/bash

# Generate ssh key
ssh-keygen -t ed25519 -f /root/.ssh/id_ed25519 -q -C "" -N ""

# Copy public ssh key to the target host
sshpass -p "password" ssh-copy-id -i /root/.ssh/id_ed25519.pub -o StrictHostKeyChecking=no root@ubuntu-t1

# Connect to target host, disable ssh connection with password authentication, and restart sshd
# "service restart ssh" will cause the container to crash, running "kill -HUP" command.
ssh root@ubuntu-t1 -p 22  << 'EOF'
sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
kill -HUP $(pgrep -x sshd)
EOF

# Avoid container termination
tail -f /dev/null
