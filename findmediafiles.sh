echo "Please enter password if prompted:"
sudo echo "I haz passwd"
sudo apt install python-pip
sudo pip3 install filemagic
sudo python3 ./python/findMTmediafiles.py | grep -v "/usr/lib" | grep -v "/usr/share"
