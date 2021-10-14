#!/bin/bash

# Storyline: Script to parse Apache log file

# Argument using the position
tFile="$1"

# Check if File Exists
#read -p  "Please Enter the name (or path to) of the Apache Log File: "
if [[ ! -f ${tFile} ]]
then
    echo "File does NOT Exist! Please specify the path to a log file"
    exit 1
fi

# Look for scanners
sed -e "s/\[//g" -e "s/\"//g" ${tFile} | \
egrep -i "test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t" | \
awk ' BEGIN { format = "%-15s %-20s %-6s %-6s %-5s %s\n"
                printf format, "IP", "Date", "Method", "Status", "Size", "URI"
                printf format, "--", "----", "------", "------", "----", "---"}
{ printf format, $1, $4, $6, $9, $10, $7 }' >> Scanners.txt

# Checks for Scanners File and Pulls out IPs
if [[ -f Scanners.txt ]]
then
    grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' Scanners.txt >> badIPs
    sort -u badIPs > BadIPs && rm badIPs
fi

# Creates files for Windows Firewall(powershell) and IPTables Rulset(bash)
if [[ BadIPs ]]
then
    echo "Creating Windows Firewall and IPTables Firewall Ruleset for BAD IPs"
    for bIP in $(cat BadIPs)
    do
      echo "netsh advfirewall firewall add rule name=\"BLOCK IP ADDRESS - ${bIP}\" dir=in action=block remoteip=${bIP}" >> BlockMaliciousIPs.ps1
      echo "iptables -A INPUT -s ${bIP} -j DROP" >> BlockMaliciousIPs.iptables
    done
fi
