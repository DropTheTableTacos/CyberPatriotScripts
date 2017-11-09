sudo apt-get install gawk
alias "listusers=gawk -F: '\$3>1000{print \$1}' /etc/passwd|grep -v nobody"
alias "listgroups=gawk -F: '{print \$1}' /etc/group"
alias "listusersgroups=for user in \$(gawk -F: '\$3>1000{print \$1}' /etc/passwd);do groups \$user|grep -v nobody;done"
alias "etcpasswd=nano /etc/passwd"