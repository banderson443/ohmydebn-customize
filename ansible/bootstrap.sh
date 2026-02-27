#!/bin/bash
set -e

# ANSIBLE BOOTSTRAP SCRIPT
# Installs Ansible and runs the local playbook

if ! command -v ansible-playbook &> /dev/null; then
    echo "Installing Ansible..."
    sudo apt update
    sudo apt install -y ansible
fi

echo "Running Ansible Playbook..."
ansible-playbook local.yml --ask-become-pass
