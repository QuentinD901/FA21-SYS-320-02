#!/bin/bash

# Storyline: Create Peer VPN Config File


#Peer's Name
echo -n "What is the client's name? "
read the_client

#Filename
pFile="${the_client}-wg0.conf"

#Check if Peer Exist
if [[ -f "${pFile}" ]]
then
    #Prompt if overwrite required
    echo "The file ${pFile} exists."
    echo -n "Do you want to overwrite it? [y|N]"
    read the_overwrite
    if [[ "${the_overwrite}" = "N" || "${the_overwrite}" == "" ]]
    then
        echo "Exit..."
        exit 0
    elif [[ "${the_overwrite}" == "y" ]]
    then
        echo "Creating the wireguard configuration file..."
    else
        echo "Invalid Value"
        exit 1
    fi
fi

#Gen Key
p="$(wg genkey)"

#Gen Pub Key
cPub="$(echo ${p} | wg pubkey)"

#Gen Pre Key
pre="$(wg genpsk)"

#EndPoint
e="$(head -1 /etc/wireguard/wg0.conf | awk ' { print $3} ')"

#Serv Key
pub="$(head -1 /etc/wireguard/wg0.conf | awk ' { print $4} ')"

#DNS
dns="$(head -1 /etc/wireguard/wg0.conf | awk ' { print $5} ')"

#MTU
mtu="$(head -1 /etc/wireguard/wg0.conf | awk ' { print $6} ')"

#KeepAlive
ka="$(head -1 /etc/wireguard/wg0.conf | awk ' { print $7} ')"

#LPORT
lport="$(shuf -n1 -i 40000-50000)"

#Default Routes
routes="$(head -1 /etc/wireguard/wg0.conf | awk ' { print $8 } ')"

#Client Config
echo "[Interface]
Address = 10.254.132.100/24
DNS = ${dns}
ListenPort = ${lport}
MTU = ${mtu}
PrivateKey = ${p} 

[Peer]
AllowdIPs = ${routes}
PeersistantKeepAlive = ${ka}
PreSharedKey = ${pre}
PublicKey = ${pub}
EndPoint = ${e}
" > ${pFile} 

#Add Peer to Server
echo "
# Q begin
[Peer]
PublicKey = ${cPub}
PreSharedKey = ${pre}
AllowedIPs = 10.0.254.132.100/32
# Q end" | tee -a /etc/wireguard/wg0.conf
