#!/bin/bash

# Stroyline: Extract IPs from emergingthreats.net and create a firewall ruleset

# Create a Firewall Ruleset Based on Version
while getopts 'hicwmp' OPTION ; do

    case "$OPTION" in

        i) iptables=${OPTION}
        ;;
        c) cisco=${OPTION}
        ;;
        w) winfirewall=${OPTION}
        ;;
        m) macosx=${OPTION}
        ;;
        p) parse=${OPTION}
        ;;
        h)
            echo ""
            echo "Usage: $(basename $0) [-i]|[-c][-w][-m][-p]"
            echo ""
            exit 1
        ;;
        *)
            echo "Invalid Value"
            exit 1
      ;;
  esac

done

# Threat File
tFile="/tmp/emerging-drop.suricata.rules"

# Targeted Threat File
ttFile="/tmp/targetedthreats.csv"

# Function - Check if Emerging Threats File Exists & Format IPs
function emerging_threats() {
if [[ -f "${tFile}" ]]
then
    #Prompt if overwrite required
    echo "The Emerging Threats File exists."
    echo -n "Do you want to overwrite it? [y|N]"
    read the_overwrite
    if [[ "${the_overwrite}" = "N" || "${the_overwrite}" == "n"|| "${the_overwrite}" == "" ]]
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
egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-drop.suricata.rules | sort -u > badIPs.txt
}

# Function - Check if Targeted Threats File Exists & Format URLs
function target_threats() {
if [[ -f "${ttFile}" ]]
then
    #Prompt if overwrite required
    echo "The Targeted Threats File exists."
    echo -n "Do you want to overwrite it? [y|N]"
    read the_overwrite
    if [[ "${the_overwrite}" = "N" || "${the_overwrite}" == "n"|| "${the_overwrite}" == "" ]]
    then
        echo "Keeping Existing Targeted Threats File"
    elif [[ "${the_overwrite}" == "y" ]]
    then
        echo "Downloading the Targeted Threats File..."
        rm -r ${ttFile}
        wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O ${ttFile}
        echo "Invalid Value"
        exit 1
    fi
fi

# Downloads Target Threats File if it Doesn't Exist
if [[ ! -f "${ttFile}" ]]
then
    echo "Downloading the Targeted Threats File"
    wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O ${ttFile}
fi

# Pulls Domains out of Targeted Threats File
cat ${ttFile} | grep '"domain"' | cut -d "," -f 2 | tr -d '""' >> badURLs.txt
}

# Check to see if switches are empty throw an error
if [[ (${iptables} == "" && ${cisco} == "" && ${winfirewall} == "" && ${macosx} == "" && ${parse} == "") ]]
then
    echo "Please specify one or more options: -i -c -w -m"
fi

#checks to see if -i is specified
if [[ ${iptables} ]]
then
    emerging_threats
    echo "Creating Inbound Drop Rule for IP-Tables"
    for eachIP in $(cat badIPs.txt)
    do
            echo "iptables -A INPUT -s ${eachIP} -j DROP" >> badIPs.iptables
    done
fi

#checks to see if -c is specified
if [[ ${cisco} ]]
then
    emerging_threats
    echo "Creating Inbound Drop Rule for Cisco Firewall"
    for eachIP in $(cat badIPs.txt)
    do
            echo "access-list OUT extended deny ip host ${eachIP} any" >> badIPs.cisco
    done
fi

#checks to see if -w is specified
if [[ ${winfirewall} ]]
then
    emerging_threats
    echo "Creating Inbound Drop Rule for Windows Firewall"
    for eachIP in $(cat badIPs.txt)
    do
            echo "netsh advfirewall firewall add rule name='Drop Inbound Malicious IP' dir=in action=block remoteip=${eachIP}" >> badIPs.winfirewall
    done
fi


#checks to see if -m is specified
if [[ ${macosx} ]]
then
    emerging_threats
    echo "Creating Inbound Drop Rule for Mac OS X"
    for eachIP in $(cat badIPs.txt)
    do
            echo "block in from ${eachIP} to any" >> badIPs.macosx
    done
fi

#checks to see if -p is specified
if [[ ${parse} ]]
then
    target_threats
    echo "Creating Cisco URL Filter"
    echo "class-map match-any BAD_URLS" >> badURLs.cisco
    for eachURL in $(cat badURLs.txt)
    do
            echo "match protocol http host \"${eachURL}\""  >> badURLs.cisco
    done
fi
