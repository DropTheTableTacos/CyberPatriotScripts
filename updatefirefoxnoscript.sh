echo "PASS THE NON-ALCHOLIC DRINK SCRIPT"
echo "Update Firefox and install noscript"
echo "------------------------------------------"
echo "Enter password if prompted"
sudo echo "I haz pazzword!"
echo "Installing wget if we don't have it"
sudo apt-get -y install wget
echo "Download NoScript"
wget -O noscript.xpi https://addons.mozilla.org/en-US/firefox/downloads/latest/722/addon-722-latest.xpi
echo "alert(\"Press Install to NoScript then CLOSE FIREFOX!\");cURL=window.location.href;cDir=cURL.substring(0,cURL.lastIndexOf(\"/\"));nURL=cDir+\"/noscript.xpi\";window.location.assign(nURL);" > a.js
echo "<html><head><title>Tacos</title></head><body><script src=\"a.js\"></script></body></html>" > html.html
firefox html.html
rm html.html
rm a.js
sudo apt-get -y update
sudo apt-get -y install firefox
