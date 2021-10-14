#!/bin/bash

# Storyline: Script to perform Security Checks

# Function - if statement to check if policy is compliant or not
function check() {
if [[ $2 != $3 ]]
then
	echo -e "\e[1;31mThe $1 is NOT compliant. The policy should be: $2, the current value is $3.\e[0m \e[1;33m$4 \e[0m" | tee -a Not-Compliant.txt
else
	echo -e "\e[1;32mThe $1 is compliant. Current Value: $3.\e[0m" | tee -a Compliant.txt
fi
}

# Check the password max days policy
pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' { print $2 } ')
# Check for the password max
check "Password Max Days" "365" "${pmax}" "\n\n Remediation \n Edit /etc/login.defs and set: \n PASS_MAX_DAYS 99999 \n to \n PASS_MAX_DAYS 365 \n"

# Check the pass min days between changes
pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' { print $2 } ')
check "Password Min Days" "14" "${pmin}" "\n\n Remediation \n Edit /etc/login.defs and set: \n PASS_MIN_DAYS 0 \n to \n PASS_MIN_DAYS 14 \n"

# Check the pass warn age
pwarn=$(egrep -i '^PASS_WARN_AGE' /etc/login.defs | awk ' { print $2 } ')
check "Password Warn Age" "7" "${pwarn}"

# Check the SSH UsePam configAccess: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)
chkSSHPAM=$(egrep -i "^USEPAM" /etc/ssh/sshd_config | awk ' { print $2 } ')
check "SSH UsePAM" "yes" "${chkSSHPAM}"

# Check perms on user home dir
echo ""
for eachDir in $(ls -l /home | egrep '^d' | awk ' { print $3 }  ')
do
	chDir=$(ls -ld /home/${eachDir} | awk ' { print $1 } ')
	check "Home Directory ${eachDir}" "drwx------" "${chDir}" "\n\n Remediation for ${eachDir} \n Run: \n chmod 700 /home/${eachDir} \n "
done
echo ""

# Check IP Forward is Disbaled
ipFor=$(egrep -i "ip_forward" /etc/sysctl.conf | tr -d "#net.ipv4.ip_forward=")
check "IP Forwarding Disabled" "0" "${ipFor}" "\n\n Remediation\n Edit /etc/sysctl.conf and set: \n net.ipv4.ip_forward=1\n to\n net.ipv4.ip_forward=0.\n Then run: \n sysctl -w\n"

# Check the ICMP redirect
icmpRe=$(egrep -i "net\.ipv4\.conf\.all\.accept_redirects" /etc/sysctl.conf | awk ' { print $3 } ')
check "ICMP Redirect" "0" "${icmpRe}"

# Check the Crontab Perms
crontab=$(stat /etc/crontab | awk 'FNR == 4 {print}')
check "Crontab Permissions" "Access: (0600/-rw-------) Uid: ( 0/ root) Gid: ( 0/ root)" "${crontab}" "\n\n Remediation \n Run: \n chown root:root /etc/crontab \n Then Run: \n chmod og-rwx /etc/crontab \n"

# Check the Cronhourly Perms
cronhr=$(stat /etc/cron.hourly | awk 'FNR == 4 {print}')
check "Cron-Hourly Permissions" "Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)" "${cronhr}" "\n\n Remediation \n Run: \n chown root:root /etc/cron.hourly \n Then Run: \n chmod og-rwx /etc/cron.hourly \n"

# Check the Crondaily Perms
crond=$(stat /etc/cron.daily | awk 'FNR == 4 {print}')
check "Cron-Daily Permissions" "Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)" "${crond}" "\n\n Remediation \n Run: \n chown root:root /etc/cron.daily \n Then Run: \n chmod og-rwx /etc/cron.daily \n"

# Check the Cronweekly Perms
cronw=$(stat /etc/cron.weekly | awk 'FNR == 4 {print}')
check "Cron-Weekly Permissions" "Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)" "${cronw}" "\n\n Remediation \n Run: \n chown root:root /etc/cron.weekly \n Then Run: \n chmod og-rwx /etc/cron.weekly \n"

# Check the Cronmonthly Perms
cronm=$(stat /etc/cron.monthly | awk 'FNR == 4 {print}')
check "Cron-Monthly Permissions" "Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)" "${cronm}" "\n\n Remediation \n Run: \n chown root:root /etc/cron.monthly \n Then Run: \n chmod og-rwx /etc/cron.monthly \n"

# Check the Passwd Perms
passp=$(stat /etc/passwd | awk 'FNR == 4 {print}')
check "Passwd File Permissions" "Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)" "${passp}"

# Check the Shadow Perms
shadow=$(stat /etc/shadow | awk 'FNR == 4 {print}')
check "Shadow File Permissions" "Access: (0640/-rw-r-----)  Uid: (    0/    root)   Gid: (   42/  shadow)" "${shadow}"

# Check the Group Perms
grp=$(stat /etc/group | awk 'FNR == 4 {print}')
check "Group File Permissions" "Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)" "${grp}"

# Check the Gshadow Perms
gshad=$(stat /etc/gshadow | awk 'FNR == 4 {print}')
check "Gshadow File Permissions" "Access: (0640/-rw-r-----)  Uid: (    0/    root)   Gid: (   42/  shadow)" "${gshad}"

# Check the Passwd- Perms
pass2=$(stat /etc/passwd- | awk 'FNR == 4 {print}')
check "Passwd- File Permissions" "Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)" "${pass2}"

# Check the Shadow- Perms
shadow2=$(stat /etc/shadow- | awk 'FNR == 4 {print}')
check "Shadow- File Permissions" "Access: (0640/-rw-r-----)  Uid: (    0/    root)   Gid: (   42/  shadow)" "${shadow2}"

# Check the Group- Perms
grp2=$(stat /etc/group- | awk 'FNR == 4 {print}')
check "Group- File Permissions" "Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)" "${grp2}"

# Check the Gshadow- Perms
gshad2=$(stat /etc/gshadow- | awk 'FNR == 4 {print}')
check "Gshadow- File Permissions" "Access: (0640/-rw-r-----)  Uid: (    0/    root)   Gid: (   42/  shadow)" "${gshad2}"

# Check No Legacy "+" Entries in Passwd
passLeg=$(egrep -i '^\+:' /etc/passwd)
check "No Legacy Passwd Entries in Passwd" "" "${passLeg}"

# Check No Legacy "+" Entries in Shadow
shadowLeg=$(egrep -i '^\+:' /etc/shadow)
check "No Legacy Passwd Entries in Shadow" "" "${ShadowLeg}"

# Check No Legacy "+" Entries in Group
grpLeg=$(egrep -i '^\+:' /etc/group)
check "No Legacy Passwd Entries in Group" "" "${grpLeg}"

# Check Only Root has UID 0
uid0=$(cat /etc/passwd | awk -F: '($3 == 0) { print $1 }')
check "Only Root has UID of 0" "root" "${uid0}"











































