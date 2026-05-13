#!/bin/sh

# Remove default user ubuntu 1000:1000 first,
# we do not need it and can collide with new sshuser user.
userdel ubuntu

# Create a user and set a password.
addgroup --gid $USER "sshuser"
useradd --gid "sshuser" --uid $USER "sshuser" --create-home
echo "sshuser:$PASSWORD" | chpasswd

# Start SSH server.
/usr/sbin/sshd -D
