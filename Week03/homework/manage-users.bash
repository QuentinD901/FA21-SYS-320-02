#!/bin/bash

#Storyline: Script to Add and Delete VPN Peers
while getopts 'hdau:' OPTION ; do

    case "$OPTION" in

        d) u_del=${OPTION}
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

# Check to see if -a, -d are empty or both specified throw an error
if [[ (${u_del} == "" && ${u_add} == "") || (${u_del} != "" && ${u_add} != "") ]]
then
    echo "Please specify -a -d and the -u and username."
fi

#Check -u is specified
if [[ (${u_del} != "" || ${u_add} != "") && ${t_user} == "" ]]
then
    echo "Plese specify a user (-u)"
    echo "Usage: $(basename $0) [-a][-d] -u username "
    exit 1
fi

#Delete User
if [[ ${u_del} ]]
then
    echo "Deleteing user..."
    sed -i "/# ${t_user} begin/,/# ${t_user} end/d" wg0.conf
fi

#Add User
if [[ ${u_add} ]]
then
    echo "Creating New User..."
    bash peer.bash ${t_user}
fi
