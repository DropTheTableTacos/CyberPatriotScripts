#!/usr/bin/env bash
echo Enter password
sudo echo I haz password
while true; do
  echo "=====USERS====="
  gawk -F: '$3>999{print $1}' /etc/passwd | grep -v nobody | sort
  echo "==============="
  echo "Would you like to:"
  echo "1. Add a user"
  echo "2. Remove a user"
  echo "q. Quit"
  read -n 1 MENU_OPTION
  case $MENU_OPTION in
    1)
      read -p "\nUsername to add:" USERTOADD
      sudo adduser $USERTOADD
      ;;
    2)
      read -p "\nUsername to DELETE:" USERTODEL
      sudo deluser $USERTODEL
      ;;
    q)
      exit
      ;;
  esac
done
