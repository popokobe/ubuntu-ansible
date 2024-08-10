FROM ubuntu:24.04

# Install package for ssh server to connect from ansible control node
RUN apt update && \
    apt install -y openssh-server sudo && \
    rm -rf /var/lib/apt/lists/*

# Make a directory for sshd (apparently the server will not start without this directory)
# Password authentication is set to yes temporarily, but after copying the public key from the ansible control node, 
# it is to be disabled
RUN mkdir /var/run/sshd && \
    echo 'root:password' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Start ssh server
CMD ["/usr/sbin/sshd", "-D"]