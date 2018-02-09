echo "--------------------------------------------"
echo "     PASS THE NON-ALCHOLIC DRINK SCRIPT     "
echo "           FIND THE BROPANTS CRAP           "
echo "--------------------------------------------"
echo "Enter password if prompted"
sudo echo "I haz pazzword!"



echo "Just to be safe lets just fix the perms on /etc/passwd, /etc/shadow, and /etc/group"
sudo chmod 644 /etc/passwd
sudo chmod 640 /etc/shadow
sudo chmod 644 /etc/group




echo "Finding setuid"
sudo find "/" -perm -4000 2> /dev/null > setuid.txt
echo "Finding setgid"
sudo find "/" -perm -2000 2> /dev/null > setgid.txt
echo "Finding setuid and setgid"
sudo find "/" -perm -6000 2> /dev/null > setuidandsetgid.txt




echo "LynisTechTips installing..."
wget -O - http://packages.cisofy.com/keys/cisofy-software-public.key | sudo apt-key add -
sudo ./lynisaptsetup.sh
sudo apt install -y apt-transport-https
sudo apt-get update
sudo apt-get install -y --force-yes lynis
echo "Running LynisTechTips"
sudo lynis audit system --cronjob > lynis.txt 2> lynis.txt
echo "Gotta get Lynis's Report on this new PC"
sudo cat /var/log/lynis-report.dat | grep "suggestion" > lynisreport.txt
sudo cat /var/log/lynis-report.dat | grep "warning" > lynisreport.txt
#   TODO:
#
#   Add a prompt for weather or not
#	to show the Lynis Report
#
echo "Hey guys, This is Austin!"




echo "Installing RKHunter"
tar xfvz rkhunter-1.4.4.tar.gz > /dev/null
cd rkhunter-1.4.4
sudo ./installer.sh --install > /dev/null
cd ..
echo "Ensure that all of the rootkit bots are AWPed as they run down Suicide"
sudo /usr/local/bin/rkhunter -c --sk --logfile rkhunter.txt -q
sudo chmod +r rkhunter.txt
nano rkhunter.txt
echo "Rootkits AWP'ed"
