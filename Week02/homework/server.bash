#!/bin/bash

# Storyline: Script to Create a Wireguard Server


#Private Key Creation
p="$(wg genkey)"

#Public Key Creation
pk="$(echo ${p} | wg pubkey)"

#Addresses
addr="10.254.132.0/24,172.16.28.0/24"

#LPORT
lp="4282"

#Format Client Config
pInfo="# ${addr} 198.199.97.163:4282 ${pk} 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0"


echo "${pInfo}
[Interface]
Address = ${addr}
#PostUp = /etc/wireguard/wg-up.bash
#PostDown = /etc/wireguard/wg-down.bash
ListenPOrt = ${lp}
PrivateKey = ${p}
" > wg0.conf 

