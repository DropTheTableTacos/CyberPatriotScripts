#!/bin/bash
if (( $EUID != 0 )); then
  echo "This script must be run with sudo or as root"
  exit
fi

echo  -e "WARNING!!! This script is similar to a DISA STIG and WILL break the system"
read -p "Press any key to continue or CTRL-C to abort"
read -p "Press any key to continue or CTRL-C to abort"
read -p "Press any key to continue or CTRL-C to abort [LAST CHANCE]"

apt-get update > /dev/null
#1.1.1.1
echo "install cramfs /bin/true" >> /etc/modprobe.d/CIS.conf
rmmod cramfs

#1.1.1.2
echo "install freevxfs /bin/true" >> /etc/modprobe.d/CIS.conf
rmmod freevxfs

#1.1.1.3
echo "install jffs2 /bin/true" >> /etc/modprobe.d/CIS.conf
rmmod jffs2

#1.1.1.4
echo "install hfs /bin/true" >> /etc/modprobe.d/CIS.conf
rmmod hfs

#1.1.1.5
echo "install hfsplus /bin/true" >> /etc/modprobe.d/CIS.conf
rmmod hfsplus

#1.1.1.6
echo "install udf /bin/true" >> /etc/modprobe.d/CIS.conf
rmmod udf

#1.3.1
apt-get install aide aide-common
aideinit

#1.3.2
(crontab -u userhere -l; echo "0 5 * * * /usr/bin/aide --config /etc/aide/aide.conf --check" ) | crontab -u userhere -

#1.4.1
chown root:root /boot/grub/grub.cfg
chmod 0400 /boot/grub/grub.cfg

#1.5.1
echo "* hard core 0" >> /etc/security/limits.conf
echo "fs.suid_dumpable = 0" >> /etc/sysctl.conf
sysctl -w fs.suid_dumpable=0

#1.5.3
echo "kernel.randomize_va_space = 2" >> /etc/sysctl.conf
sysctl -w kernel.randomize_va_space = 2

#1.5.4
prelink -ua
apt-get -y remove prelink

#1.6.1.1
sed -i .bak 's/selinux=0//g' /etc/default/grub
sed -i .bak 's/enforcing=0//g' /etc/default/grub

#1.6.1.2
sed -i .bak 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config

#1.6.2.1
sed -i .bak 's/apparmor=0//g' /etc/default/grub
update-grub

#1.6.2.2
aa-enforce /etc/apparmor.d/*

#1.6.3
apt-get install -y selinux apparmor

#1.7.1.1
sed -i .bak 's/\\[mrsv]//g' /etc/motd

#1.7.1.2
echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue

#1.7.1.3
echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue.net

#1.7.1.4
chown root:root /etc/motd
chmod 644 /etc/motd

#1.7.1.5
chown root:root /etc/issue
chmod 644 /etc/issue

#1.7.1.6
chown root:root /etc/issue.net
chmod 644 /etc/issue.net

#1.8
apt-get -y upgrade

#2.1.1
sed -i .bak 's/^chargen/#chargen/' /etc/inetd.*

#2.1.2
sed -i .bak 's/^daytime/#daytime/' /etc/inetd.*

#2.1.3
sed -i .bak 's/^discard/#discard/' /etc/inetd.*

#2.1.4
sed -i .bak 's/^echo/#echo/' /etc/inetd.*

#2.1.5
sed -i .bak 's/^time/#time/' /etc/inetd.*

#2.1.6
sed -i .bak 's/^shell/#shell/' /etc/inetd.*
sed -i .bak 's/^login/#login/' /etc/inetd.*
sed -i .bak 's/^exec/#exec/' /etc/inetd.*

#2.1.7
sed -i .bak 's/^talk/#talk/' /etc/inetd.*
sed -i .bak 's/^ntalk/#ntalk/' /etc/inetd.*

#2.1.8
sed -i .bak 's/^telnet/#telnet/' /etc/inetd.*

#2.1.9
sed -i .bak 's/^tftp/#tftp/' /etc/inetd.*

#2.1.10
systemctl disable xinetd

#2.1.11
apt-get -y remove openbsd-inetd

#2.2.1.1
apt-get -y install ntp

#2.2.3
systemctl disable avahi-daemon

#2.2.4
systemctl disable cups

#2.2.5
systemctl disable isc-dhcp-server
systemctl disable isc-dhcp-server6

#2.2.6
systemctl disable slapd

#2.2.7
systemctl disable nfs-server
systemctl disable rpcbind

#2.2.8
systemctl disable bind9

#2.2.9
systemctl disable vsftpd

#2.2.10
systemctl disable apache2

#2.2.11
systemctl disable dovecot

#2.2.12
systemctl disable smbd

#2.2.13
systemctl disable squid

#2.2.14
systemctl disable snmpd

#2.2.16
systemctl disable rsync

#2.2.17
systemctl disable nis

#2.3.1, 2.3.2, 2.3.3, 2.3.4, 2.3.5
apt remove nis rsh-client rsh-redone-client talk telnet ldap-utils

#3.1.1
sysctl -w net.ipv4.ip_forward=0
sysctl -w net.ipv4.route.flush=1

#3.1.2
sysctl -w net.ipv4.conf.all.send_redirects=0
sysctl -w net.ipv4.conf.default.send_redirects=0
sysctl -w net.ipv4.route.flush=1

#3.2.1
sysctl -w net.ipv4.conf.all.secure_redirects=0
sysctl -w net.ipv4.conf.default.secure_redirects=0
sysctl -w net.ipv4.route.flush=1

#3.2.2
sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.default.accept_redirects=0
sysctl -w net.ipv4.route.flush=1

#3.2.3
sysctl -w net.ipv4.conf.all.secure_redirects=0
sysctl -w net.ipv4.conf.default.secure_redirects=0
sysctl -w net.ipv4.route.flush=1

#3.2.4
sysctl -w net.ipv4.conf.all.log_martians=1
sysctl -w net.ipv4.conf.default.log_martians=1
sysctl -w net.ipv4.route.flush=1

#3.2.5
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
sysctl -w net.ipv4.route.flush=1

#3.2.6
sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
sysctl -w net.ipv4.route.flush=1

#3.2.7
sysctl -w net.ipv4.conf.all.rp_filter = 1
sysctl -w net.ipv4.conf.default.rp_filter = 1
sysctl -w net.ipv4.route.flush=1

#3.2.8
sysctl -w net.ipv4.tcp_syncookies=1
sysctl -w net.ipv4.route.flush=1

#3.4.1
apt install tcpd

#3.4.3
echo "ALL: ALL" >> /etc/hosts.deny

#3.4.4, 3.4.5
chown root:root /etc/hosts.*
chmod 644 /etc/hosts.*

#3.5.1, 3.5.2, 3.5.3, 3.5.4
echo "install dccp /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install sctp /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install rds /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install ticp /bin/true" >> /etc/modprobe.d/CIS.conf

#3.6
apt install ufw
ufw enable

#4.1.2
systemctl enable auditd

#5.1.1
systemctl enable cron

#5.1.2, 5.1.3, 5.1.4, 5.1.5, 5.1.6, 5.1.7
chown root:root /etc/crontab /etc/cron.hourly /etc/cron.daily /etc/cron.weekly /etc/cron.monthly /etc/cron.d
chmod og-rwx /etc/crontab /etc/cron.hourly /etc/cron.daily /etc/cron.weekly /etc/cron.monthly /etc/cron.d

#5.1.8
rm /etc/cron.deny
rm /etc/at.deny
touch /etc/cron.allow
touch /etc/at.allow
chmod og-rwx /etc/cron.allow
chmod og-rwx /etc/at.allow
chown root:root /etc/cron.allow
chown root:root /etc/at.allow

#5.2.1
chown root:root /etc/ssh/sshd_config
chmod og-rwx /etc/ssh/sshd_config

#6.1.2, 6.1.4
chown root:root /etc/passwd /etc/group
chmod 644 /etc/passwd /etc/group

#6.1.3, 6.1.5, 6.1.7, 6.1.9
chown root:shadow /etc/shadow /etc/gshadow /etc/shadow- /etc/gshadow-
chmod o-rwx,g-rwx /etc/shadow /etc/gshadow /etc/shadow- /etc/gshadow-

#6.1.6, 6.1.8
chown root:root /etc/passwd- /etc/group-
chmod u-x,go-wx /etc/passwd- /etc/group-
