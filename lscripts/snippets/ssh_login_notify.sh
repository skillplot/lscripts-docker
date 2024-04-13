#!/bin/bash

# Monitor SSH login events and trigger desktop notifications

tail -n0 -F /var/log/auth.log | grep --line-buffered "sshd.*session opened" | while read -r line; do
    user=$(echo "$line" | awk '{print $9}')
    ip=$(echo "$line" | awk '{print $11}')
    notify-send "SSH Login" "User $user logged in from $ip" --icon=dialog-information
done

