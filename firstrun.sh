echo        DROP THE TABLE TACOS SCRIPT        
echo      Stuff that should happen FIRST       
echo ------------------------------------------
echo Enter password if prompted
sudo echo I haz pazzword!

echo Running updates...
sudo apt update
sudo apt -y install aptitude

sudo aptitude -y update
sudo aptitude -y upgrade

echo Install script stuff
sudo aptitude -y install git python3-dev python3-pip apt-transport-https openssh-server augeas-tools gawk libuser members

echo Nice shell setup because I\'m picky
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh --silent
. ~/.bashrc
sudo pip3 install thefuck

#echo Disable the guest account
#sudo sh -c 'printf "[Seat:*]\nallow-guest=false\n" >/etc/lightdm/lightdm.conf.d/50-no-guest.conf'
