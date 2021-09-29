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
        echo "Keeping Existing Emerging Threats File"
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
while getopts 'hicwm' OPTION ; do

    case "${OPTION" in

        i) iptables=${OPTION}
        ;;
        c) cisco=${OPTION}
        ;;
        w) winfirewall=${OPTION}
        ;;
        m) macosx=${OPTION}
        ;;
        h)
            echo ""
            echo "Usage: $(basename $0) [-i]|[-c][-w][-m]"
            echo ""
            exit 1
        ;;
        *)
            echo "Invalid Value"
            exit 1
      ;;
  esac

done


# Check to see if switches are empty throw an error
if [[ (${iptables} == "" && ${cisco} == "" && ${winfirewall} == "" && ${macosx} == "") ]]
then
    echo "Please specify one or more options: -i -c -w -m"
fi

#checks to see if -i is specified
if [[ ${iptables} ]]
then
    echo "Creating Inbound Drop Rule for IP-Tables"
    for eachIP in $(cat badIPs.txt)
    do
            echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables
    done
fi

#checks to see if -c is specified
if [[ ${cisco} ]]
then
    echo "Creating Inbound Drop Rule for Cisco Firewall"
    for eachIP in $(cat badIPs.txt)
    do
            echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.cisco
    done
fi

#checks to see if -w is specified
if [[ ${winfirewall} ]]
then
    echo "Creating Inbound Drop Rule for Windows Firewall"
    for eachIP in $(cat badIPs.txt)
    do
            echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.winfirewall
    done
fi


#checks to see if -m is specified
if [[ ${macosx} ]]
then
    echo "Creating Inbound Drop Rule for Mac OS X"
    for eachIP in $(cat badIPs.txt)
    do
            echo "block in from ${eachIP} to any" | tee -a badIPs.macosx
    done
fi

