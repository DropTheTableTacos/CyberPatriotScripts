#!/bin/bash
echo Securing AppArmor
sudo apt install apparmor-utils
sudo aa-enforce /etc/apparmor.d/*

echo Securing Banners
sudo chown root:root /etc/motd
sudo chmod 644 /etc/motd

sudo chown root:root /etc/issue
sudo chmod 644 /etc/issue

sudo chown root:root /etc/issue.net
sudo chmod 644 /etc/issue.net

# Insert 2.1 stuff here!
read -p "Are any xinetd services required? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    sudo systemctl disable xinetd
fi

# 2.1.11
sudo apt remove openbsd-inetd

# 2.2.4
sudo systemctl disable cups

# 2.2.5
sudo systemctl disable isc-dhcp-server
sudo systemctl disable isc-dhcp-server6

# 2.2.6
sudo systemctl disable slapd

# 2.2.7
read -p "Is NFS required? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    sudo systemctl disable nfs-server
fi
sudo systemctl disable rpcbind

# 2.2.8
sudo systemctl disable bind9

# 2.2.11
sudo systemctl disable dovecot

# 2.2.13
sudo systemctl disable squid

# 2.2.14
sudo systemctl disable snmpd

# 2.2.16
sudo systemctl disable rsync


