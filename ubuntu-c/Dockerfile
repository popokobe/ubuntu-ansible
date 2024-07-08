FROM ubuntu:24.04

# Install Ansible
RUN apt update && \
    apt install -y software-properties-common && \
    apt-add-repository --yes --update ppa:ansible/ansible && \
    apt install -y ansible

# Install utilities
RUN apt install -y \
    vim

WORKDIR /etc/ansible