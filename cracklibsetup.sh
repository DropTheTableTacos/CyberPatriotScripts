echo "PASS THE NON-ALCHOLIC DRINK SCRIPT"
echo "Disable Username Display and disable the Guest Account"
echo ------------------------------------------ 
echo "Enter password if prompted"
sudo echo "I haz pazzword!"
sudo apt-get install libpam-cracklib
cat /etc/pam.d/common-password|grep "pam_cracklib.so"