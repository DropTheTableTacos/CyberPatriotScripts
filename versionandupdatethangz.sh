echo "PASS THE NON-ALCHOLIC DRINK SCRIPT"
echo "apt-get update stuff"
echo "------------------------------------------"
echo "Enter password if prompted"
sudo echo "I haz pazzword!"
sudo lsb_release –a | cat > ~/Desktop/version.txt
echo "Version saved to Desktop.... Updating stuff"
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y autoremove
sudo apt-get -y autoclean