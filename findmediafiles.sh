echo "Please enter password if prompted:"
sudo echo "I haz passwd"
sudo apt install python-pip
sudo pip install filemagic
sudo python ./python/findmediafiles.py | grep -v "/usr/lib" | grep -v "/usr/share"
