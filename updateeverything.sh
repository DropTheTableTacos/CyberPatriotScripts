echo "       DROP THE TABLE TACOS SCRIPT        "
echo "           apt-get update stuff           "
echo "------------------------------------------"
sudo apt-get -y install aptitude
echo "Enter password if prompted"
sudo echo "I haz pazzword!"
sudo aptitude -y update
sudo aptitude -y upgrade
sudo aptitude -y autoremove
sudo aptitude -y autoclean
