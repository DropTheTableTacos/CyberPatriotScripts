sudo apt install -y git python3-dev python3-pip
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh --silent
sudo pip3 install thefuck
#echo "eval $(thefuck --alias oops --enable-experimental-instant-mode)" >> ~/.bashrc
