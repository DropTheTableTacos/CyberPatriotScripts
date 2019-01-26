echo " PASS THE NON-ALCHOLIC DRINK SCRIPT "
echo "     Install and Secure OpenSSH     "
echo "------------------------------------"
echo "Enter password if requested"
sudo echo "We have sudo!"
sudo apt-get update
sudo apt-get install -y openssh-server
sudo augtool -b --file=./augtool/sshd.atool