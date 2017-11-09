echo "PASS THE NON-ALCHOLIC DRINK SCRIPT"
echo "Disable Username Display"
echo ------------------------------------------ 
echo "Enter password if prompted"
sudo echo "I haz pazzword!"
echo "greeter-hide-users=true" | sudo tee -a /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf > /dev/null
echo "greeter-show-manual-login=true" | sudo tee -a /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf > /dev/null
sudo gsettings set com.canonical.unity-greeter logo ""