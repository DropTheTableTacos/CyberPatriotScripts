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
read -p "Are you sure? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    sudo systemctl disable xinetd
fi
