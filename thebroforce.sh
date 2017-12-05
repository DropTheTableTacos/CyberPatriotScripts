echo "-----------------------------------------"
echo "  PASS THE NON-ALCHOLIC BEVERAGE SCRIPT  "
echo "      HELP BROPANTS IS RETALERATING      "
echo "-----------------------------------------"
echo "Enter password if prompted"
sudo echo "I haz pazzword!"

#Get things
sudo apt-get update
sudo apt-get install -y gawk


#Look through normal users to see if they are on the list that CP gives us
echo "Enter names of allowed users below with a new line in between each one" > input
nano -L input 
cat input | sort | tail -n +2 - > temp && mv temp input
gawk -F: '$4 >= 1000{if($4 < 9999) print $1}' /etc/passwd | sort > normalusers
diff --suppress-common-lines input normalusers | cut -c 1-2 - | cat