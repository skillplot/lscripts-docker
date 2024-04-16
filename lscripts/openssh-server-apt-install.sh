#!/bin/bash


function ssh.main() {
  ## Backup the original SSH configuration file
  sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config_backup

  ## Configure SSH to disallow root login, password authentication, enable PubkeyAuthentication, and set LogLevel to VERBOSE
  sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
  sudo sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
  sudo sed -i '/^#PubkeyAuthentication/c\PubkeyAuthentication yes' /etc/ssh/sshd_config
  sudo sed -i '/^#LogLevel/c\LogLevel VERBOSE' /etc/ssh/sshd_config

  echo "SSH server configuration complete."
}


function ssh.main() {

  # Update package list
  sudo apt update

  ## Install SSH server
  sudo apt install -y openssh-server

  ## configure SSH server
  ssh.config "$@"

  ## Restart SSH service to apply changes
  sudo systemctl restart ssh

  echo "SSH server installation and configuration completed."
}

ssh.main "$@"
