#!/usr/bin/env bash
echo Enter password
sudo echo I haz password
while true; do
  echo "=====ADMINS====="
  sudo members sudo | tr "\n" " "
  echo "================"
  echo "Would you like to:"
  echo "1. Admin a user"
  echo "2. UNAdmin a user"
  echo "q. Quit"
  read -n 1 MENU_OPTION
  case $MENU_OPTION in
    1)
      read -p "\nUser to admin:" USERTOADD
      sudo gpasswd -a $USERTOADD sudo
      sudo gpasswd -a $USERTOADD adm
      ;;
    2)
      read -p "\nUser to unadmin:" USERTODEL
      sudo gpasswd -d $USERTODEL sudo
      sudo gpasswd -d $USERTODEL adm
      ;;
    q)
      exit
      ;;
  esac
done
