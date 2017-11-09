sudo rm /etc/at.deny
sudo rm /etc/cron.deny
echo "root" | sudo tee -a /etc/at.allow | sudo tee -a /etc/at.allow > /dev/null