#!/bin/bash

# Stroyline: Extract IPs from emergingthreats.net and create a firewall ruleset

# Threat File
tFile="/tmp/emerging-drop.suricata.rules"

# Check if Emerging Threats File Exists
if [[ -f "${tFile}" ]]
then
    #Prompt if overwrite required
    echo "The Emerging Threats File exists."
    echo -n "Do you want to overwrite it? [y|N]"
    read the_overwrite
    if [[ "${the_overwrite}" = "N" || "${the_overwrite}" == "" ]]
    then
        echo "Exit..."
    elif [[ "${the_overwrite}" == "y" ]]
    then
        echo "Downloading the Emerging Threats File..."
        rm -r ${tFile}
        wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules
    else
        echo "Invalid Value"
        exit 1
    fi
fi

# Downloads Emerging Threats File if it Doesn't Exist
if [[ ! -f "${tFile}" ]]
then
    echo "Downloading the Emerging Threats File"
    wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules
fi


# Regex to Extract the Networks
egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-drop.suricata.rules | sort -u | tee badIPs.txt

# Create a Firewall Ruleset Based on Version
while getopts 'hicnwm' OPTION ; do

    case "$OPTION" in

        i) iptables=${OPTION}
        ;;
        a) u_add=${OPTION}
        ;;
        u) t_user=${OPTARG}
        ;;
        h)
            echo ""
            echo "Usage: $(basename $0) [-a]|[-d] -u username"
            echo ""
            exit 1
        ;;
        *)
            echo "Invalid Value"
            exit 1
      ;;
  esac

done








for eachIP in $(cat badIPs.txt)
do
        echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables
done

