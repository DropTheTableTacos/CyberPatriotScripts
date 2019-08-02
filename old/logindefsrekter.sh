echo "#" > newlogin.def
echo "# /etc/login.defs - Configuration control definitions for the login package." >> newlogin.def
echo "#" >> newlogin.def
echo "# Three items must be defined:  MAIL_DIR, ENV_SUPATH, and ENV_PATH." >> newlogin.def
echo "# If unspecified, some arbitrary (and possibly incorrect) value will" >> newlogin.def
echo "# be assumed.  All other items are optional - if not specified then" >> newlogin.def
echo "# the described action or option will be inhibited." >> newlogin.def
echo "#" >> newlogin.def
echo "# Comment lines (lines beginning with \"#\") and blank lines are ignored." >> newlogin.def
echo "#" >> newlogin.def
echo "# Modified for Linux.  --marekm" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "# REQUIRED for useradd/userdel/usermod" >> newlogin.def
echo "#   Directory where mailboxes reside, _or_ name of file, relative to the" >> newlogin.def
echo "#   home directory.  If you _do_ define MAIL_DIR and MAIL_FILE," >> newlogin.def
echo "#   MAIL_DIR takes precedence." >> newlogin.def
echo "#" >> newlogin.def
echo "#   Essentially:" >> newlogin.def
echo "#      - MAIL_DIR defines the location of users mail spool files" >> newlogin.def
echo "#        (for mbox use) by appending the username to MAIL_DIR as defined" >> newlogin.def
echo "#        below." >> newlogin.def
echo "#      - MAIL_FILE defines the location of the users mail spool files as the" >> newlogin.def
echo "#        fully-qualified filename obtained by prepending the user home" >> newlogin.def
echo "#        directory before $MAIL_FILE" >> newlogin.def
echo "#" >> newlogin.def
echo "# NOTE: This is no more used for setting up users MAIL environment variable" >> newlogin.def
echo "#       which is, starting from shadow 4.0.12-1 in Debian, entirely the" >> newlogin.def
echo "#       job of the pam_mail PAM modules" >> newlogin.def
echo "#       See default PAM configuration files provided for" >> newlogin.def
echo "#       login, su, etc." >> newlogin.def
echo "#" >> newlogin.def
echo "# This is a temporary situation: setting these variables will soon" >> newlogin.def
echo "# move to /etc/default/useradd and the variables will then be" >> newlogin.def
echo "# no more supported" >> newlogin.def
echo "MAIL_DIR        /var/mail" >> newlogin.def
echo "#MAIL_FILE      .mail" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# Enable logging and display of /var/log/faillog login failure info." >> newlogin.def
echo "# This option conflicts with the pam_tally PAM module." >> newlogin.def
echo "#" >> newlogin.def
echo "FAILLOG_ENAB		yes" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# Enable display of unknown usernames when login failures are recorded." >> newlogin.def
echo "#" >> newlogin.def
echo "# WARNING: Unknown usernames may become world readable. " >> newlogin.def
echo "# See #290803 and #298773 for details about how this could become a security" >> newlogin.def
echo "# concern" >> newlogin.def
echo "LOG_UNKFAIL_ENAB	no" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# Enable logging of successful logins" >> newlogin.def
echo "#" >> newlogin.def
echo "LOG_OK_LOGINS		no" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# Enable \"syslog\" logging of su activity - in addition to sulog file logging." >> newlogin.def
echo "# SYSLOG_SG_ENAB does the same for newgrp and sg." >> newlogin.def
echo "#" >> newlogin.def
echo "SYSLOG_SU_ENAB		yes" >> newlogin.def
echo "SYSLOG_SG_ENAB		yes" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# If defined, all su activity is logged to this file." >> newlogin.def
echo "#" >> newlogin.def
echo "#SULOG_FILE	/var/log/sulog" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# If defined, file which maps tty line to TERM environment parameter." >> newlogin.def
echo "# Each line of the file is in a format something like \"vt100  tty01\"." >> newlogin.def
echo "#" >> newlogin.def
echo "#TTYTYPE_FILE	/etc/ttytype" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# If defined, login failures will be logged here in a utmp format" >> newlogin.def
echo "# last, when invoked as lastb, will read /var/log/btmp, so..." >> newlogin.def
echo "#" >> newlogin.def
echo "FTMP_FILE	/var/log/btmp" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# If defined, the command name to display when running \"su -\".  For" >> newlogin.def
echo "# example, if this is defined as \"su\" then a \"ps\" will display the" >> newlogin.def
echo "# command is \"-su\".  If not defined, then \"ps\" would display the" >> newlogin.def
echo "# name of the shell actually being run, e.g. something like \"-sh\"." >> newlogin.def
echo "#" >> newlogin.def
echo "SU_NAME		su" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# If defined, file which inhibits all the usual chatter during the login" >> newlogin.def
echo "# sequence.  If a full pathname, then hushed mode will be enabled if the" >> newlogin.def
echo "# user's name or shell are found in the file.  If not a full pathname, then" >> newlogin.def
echo "# hushed mode will be enabled if the file exists in the user's home directory." >> newlogin.def
echo "#" >> newlogin.def
echo "HUSHLOGIN_FILE	.hushlogin" >> newlogin.def
echo "#HUSHLOGIN_FILE	/etc/hushlogins" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# *REQUIRED*  The default PATH settings, for superuser and normal users." >> newlogin.def
echo "#" >> newlogin.def
echo "# (they are minimal, add the rest in the shell startup files)" >> newlogin.def
echo "ENV_SUPATH	PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" >> newlogin.def
echo "ENV_PATH	PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# Terminal permissions" >> newlogin.def
echo "#" >> newlogin.def
echo "#	TTYGROUP	Login tty will be assigned this group ownership." >> newlogin.def
echo "#	TTYPERM		Login tty will be set to this permission." >> newlogin.def
echo "#" >> newlogin.def
echo "# If you have a \"write\" program which is \"setgid\" to a special group" >> newlogin.def
echo "# which owns the terminals, define TTYGROUP to the group number and" >> newlogin.def
echo "# TTYPERM to 0620.  Otherwise leave TTYGROUP commented out and assign" >> newlogin.def
echo "# TTYPERM to either 622 or 600." >> newlogin.def
echo "#" >> newlogin.def
echo "# In Debian /usr/bin/bsd-write or similar programs are setgid tty" >> newlogin.def
echo "# However, the default and recommended value for TTYPERM is still 0600" >> newlogin.def
echo "# to not allow anyone to write to anyone else console or terminal" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "# Users can still allow other people to write them by issuing " >> newlogin.def
echo "# the \"mesg y\" command." >> newlogin.def
echo -e "\n" >> newlogin.def
echo "TTYGROUP	tty" >> newlogin.def
echo "TTYPERM		0600" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# Login configuration initializations:" >> newlogin.def
echo "#" >> newlogin.def
echo "#	ERASECHAR	Terminal ERASE character ('\010' = backspace)." >> newlogin.def
echo "#	KILLCHAR	Terminal KILL character ('\025' = CTRL/U)." >> newlogin.def
echo "#	UMASK		Default \"umask\" value." >> newlogin.def
echo "#" >> newlogin.def
echo "# The ERASECHAR and KILLCHAR are used only on System V machines." >> newlogin.def
echo "# " >> newlogin.def
echo "# UMASK is the default umask value for pam_umask and is used by" >> newlogin.def
echo "# useradd and newusers to set the mode of the new home directories." >> newlogin.def
echo "# 022 is the \"historical\" value in Debian for UMASK" >> newlogin.def
echo "# 027, or even 077, could be considered better for privacy" >> newlogin.def
echo "# There is no One True Answer here : each sysadmin must make up his/her" >> newlogin.def
echo "# mind." >> newlogin.def
echo "#" >> newlogin.def
echo "# If USERGROUPS_ENAB is set to \"yes\", that will modify this UMASK default value" >> newlogin.def
echo "# for private user groups, i. e. the uid is the same as gid, and username is" >> newlogin.def
echo "# the same as the primary group name: for these, the user permissions will be" >> newlogin.def
echo "# used as group permissions, e. g. 022 will become 002." >> newlogin.def
echo "#" >> newlogin.def
echo "# Prefix these values with \"0\" to get octal, \"0x\" to get hexadecimal." >> newlogin.def
echo "#" >> newlogin.def
echo "ERASECHAR	0177" >> newlogin.def
echo "KILLCHAR	025" >> newlogin.def
echo "UMASK		022" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# Password aging controls:" >> newlogin.def
echo "#" >> newlogin.def
echo "#	PASS_MAX_DAYS	Maximum number of days a password may be used." >> newlogin.def
echo "#	PASS_MIN_DAYS	Minimum number of days allowed between password changes." >> newlogin.def
echo "#	PASS_WARN_AGE	Number of days warning given before a password expires." >> newlogin.def
echo "#" >> newlogin.def
echo "PASS_MAX_DAYS	30" >> newlogin.def
echo "PASS_MIN_DAYS	15" >> newlogin.def
echo "PASS_WARN_AGE	7" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# Min/max values for automatic uid selection in useradd" >> newlogin.def
echo "#" >> newlogin.def
echo "UID_MIN			 1000" >> newlogin.def
echo "UID_MAX			60000" >> newlogin.def
echo "# System accounts" >> newlogin.def
echo "#SYS_UID_MIN		  100" >> newlogin.def
echo "#SYS_UID_MAX		  999" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# Min/max values for automatic gid selection in groupadd" >> newlogin.def
echo "#" >> newlogin.def
echo "GID_MIN			 1000" >> newlogin.def
echo "GID_MAX			60000" >> newlogin.def
echo "# System accounts" >> newlogin.def
echo "#SYS_GID_MIN		  100" >> newlogin.def
echo "#SYS_GID_MAX		  999" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# Max number of login retries if password is bad. This will most likely be" >> newlogin.def
echo "# overriden by PAM, since the default pam_unix module has it's own built" >> newlogin.def
echo "# in of 3 retries. However, this is a safe fallback in case you are using" >> newlogin.def
echo "# an authentication module that does not enforce PAM_MAXTRIES." >> newlogin.def
echo "#" >> newlogin.def
echo "LOGIN_RETRIES		5" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# Max time in seconds for login" >> newlogin.def
echo "#" >> newlogin.def
echo "LOGIN_TIMEOUT		60" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# Which fields may be changed by regular users using chfn - use" >> newlogin.def
echo "# any combination of letters \"frwh\" (full name, room number, work" >> newlogin.def
echo "# phone, home phone).  If not defined, no changes are allowed." >> newlogin.def
echo "# For backward compatibility, \"yes\" = \"rwh\" and \"no\" = \"frwh\"." >> newlogin.def
echo "# " >> newlogin.def
echo "CHFN_RESTRICT		rwh" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# Should login be allowed if we can't cd to the home directory?" >> newlogin.def
echo "# Default in no." >> newlogin.def
echo "#" >> newlogin.def
echo "DEFAULT_HOME	yes" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# If defined, this command is run when removing a user." >> newlogin.def
echo "# It should remove any at/cron/print jobs etc. owned by" >> newlogin.def
echo "# the user to be removed (passed as the first argument)." >> newlogin.def
echo "#" >> newlogin.def
echo "#USERDEL_CMD	/usr/sbin/userdel_local" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# Enable setting of the umask group bits to be the same as owner bits" >> newlogin.def
echo "# (examples: 022 -> 002, 077 -> 007) for non-root users, if the uid is" >> newlogin.def
echo "# the same as gid, and username is the same as the primary group name." >> newlogin.def
echo "#" >> newlogin.def
echo "# If set to yes, userdel will remove the user´s group if it contains no" >> newlogin.def
echo "# more members, and useradd will create by default a group with the name" >> newlogin.def
echo "# of the user." >> newlogin.def
echo "#" >> newlogin.def
echo "USERGROUPS_ENAB yes" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# Instead of the real user shell, the program specified by this parameter" >> newlogin.def
echo "# will be launched, although its visible name (argv[0]) will be the shell's." >> newlogin.def
echo "# The program may do whatever it wants (logging, additional authentification," >> newlogin.def
echo "# banner, ...) before running the actual shell." >> newlogin.def
echo "#" >> newlogin.def
echo "# FAKE_SHELL /bin/fakeshell" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# If defined, either full pathname of a file containing device names or" >> newlogin.def
echo "# a ":" delimited list of device names.  Root logins will be allowed only" >> newlogin.def
echo "# upon these devices." >> newlogin.def
echo "#" >> newlogin.def
echo "# This variable is used by login and su." >> newlogin.def
echo "#" >> newlogin.def
echo "#CONSOLE	/etc/consoles" >> newlogin.def
echo "#CONSOLE	console:tty01:tty02:tty03:tty04" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# List of groups to add to the user's supplementary group set" >> newlogin.def
echo "# when logging in on the console (as determined by the CONSOLE" >> newlogin.def
echo "# setting).  Default is none." >> newlogin.def
echo "#" >> newlogin.def
echo "# Use with caution - it is possible for users to gain permanent" >> newlogin.def
echo "# access to these groups, even when not logged in on the console." >> newlogin.def
echo "# How to do it is left as an exercise for the reader..." >> newlogin.def
echo "#" >> newlogin.def
echo "# This variable is used by login and su." >> newlogin.def
echo "#" >> newlogin.def
echo "#CONSOLE_GROUPS		floppy:audio:cdrom" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# If set to \"yes\", new passwords will be encrypted using the MD5-based" >> newlogin.def
echo "# algorithm compatible with the one used by recent releases of FreeBSD." >> newlogin.def
echo "# It supports passwords of unlimited length and longer salt strings." >> newlogin.def
echo "# Set to \"no\" if you need to copy encrypted passwords to other systems" >> newlogin.def
echo "# which don't understand the new algorithm.  Default is "no"." >> newlogin.def
echo "#" >> newlogin.def
echo "# This variable is deprecated. You should use ENCRYPT_METHOD." >> newlogin.def
echo "#" >> newlogin.def
echo "#MD5_CRYPT_ENAB	no" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# If set to MD5 , MD5-based algorithm will be used for encrypting password" >> newlogin.def
echo "# If set to SHA256, SHA256-based algorithm will be used for encrypting password" >> newlogin.def
echo "# If set to SHA512, SHA512-based algorithm will be used for encrypting password" >> newlogin.def
echo "# If set to DES, DES-based algorithm will be used for encrypting password (default)" >> newlogin.def
echo "# Overrides the MD5_CRYPT_ENAB option" >> newlogin.def
echo "#" >> newlogin.def
echo "# Note: It is recommended to use a value consistent with" >> newlogin.def
echo "# the PAM modules configuration." >> newlogin.def
echo "#" >> newlogin.def
echo "ENCRYPT_METHOD SHA512" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#" >> newlogin.def
echo "# Only used if ENCRYPT_METHOD is set to SHA256 or SHA512." >> newlogin.def
echo "#" >> newlogin.def
echo "# Define the number of SHA rounds." >> newlogin.def
echo "# With a lot of rounds, it is more difficult to brute forcing the password." >> newlogin.def
echo "# But note also that it more CPU resources will be needed to authenticate" >> newlogin.def
echo "# users." >> newlogin.def
echo "#" >> newlogin.def
echo "# If not specified, the libc will choose the default number of rounds (5000)." >> newlogin.def
echo "# The values must be inside the 1000-999999999 range." >> newlogin.def
echo "# If only one of the MIN or MAX values is set, then this value will be used." >> newlogin.def
echo "# If MIN > MAX, the highest value will be used." >> newlogin.def
echo "#" >> newlogin.def
echo "# SHA_CRYPT_MIN_ROUNDS 5000" >> newlogin.def
echo "# SHA_CRYPT_MAX_ROUNDS 5000" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "################# OBSOLETED BY PAM ##############" >> newlogin.def
echo "#						#" >> newlogin.def
echo "# These options are now handled by PAM. Please	#" >> newlogin.def
echo "# edit the appropriate file in /etc/pam.d/ to	#" >> newlogin.def
echo "# enable the equivelants of them." >> newlogin.def
echo "#" >> newlogin.def
echo "###############" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "#MOTD_FILE" >> newlogin.def
echo "#DIALUPS_CHECK_ENAB" >> newlogin.def
echo "#LASTLOG_ENAB" >> newlogin.def
echo "#MAIL_CHECK_ENAB" >> newlogin.def
echo "#OBSCURE_CHECKS_ENAB" >> newlogin.def
echo "#PORTTIME_CHECKS_ENAB" >> newlogin.def
echo "#SU_WHEEL_ONLY" >> newlogin.def
echo "#CRACKLIB_DICTPATH" >> newlogin.def
echo "#PASS_CHANGE_TRIES" >> newlogin.def
echo "#PASS_ALWAYS_WARN" >> newlogin.def
echo "#ENVIRON_FILE" >> newlogin.def
echo "#NOLOGINS_FILE" >> newlogin.def
echo "#ISSUE_FILE" >> newlogin.def
echo "#PASS_MIN_LEN" >> newlogin.def
echo "#PASS_MAX_LEN" >> newlogin.def
echo "#ULIMIT" >> newlogin.def
echo "#ENV_HZ" >> newlogin.def
echo "#CHFN_AUTH" >> newlogin.def
echo "#CHSH_AUTH" >> newlogin.def
echo "#FAIL_DELAY" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "################# OBSOLETED #######################" >> newlogin.def
echo "#						  #" >> newlogin.def
echo "# These options are no more handled by shadow.    #" >> newlogin.def
echo "#                                                 #" >> newlogin.def
echo "# Shadow utilities will display a warning if they #" >> newlogin.def
echo "# still appear.                                   #" >> newlogin.def
echo "#                                                 #" >> newlogin.def
echo "###################################################" >> newlogin.def
echo -e "\n" >> newlogin.def
echo "# CLOSE_SESSIONS" >> newlogin.def
echo "# LOGIN_STRING" >> newlogin.def
echo "# NO_PASSWORD_CONSOLE" >> newlogin.def
echo "# QMAIL_DIR" >> newlogin.def
#Lol done with this massive wall of text
echo "     PASS THE NON-ALCHOLIC DRINK SCRIPT     "
echo "           FIND THE BROPANTS CRAP           "
echo "--------------------------------------------"
echo "Enter password if prompted"
sudo echo "I haz pazzword!"
sudo cp /etc/login.defs ./logins.defs.bak
cat newlogin.def | sudo tee /etc/login.defs > /dev/null
