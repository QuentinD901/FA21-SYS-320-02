#!/bin/bash

#Storyline: Menu for admin, VPN, and Security Functions

#Function for Invalid Inputs
function invlaid_opt() {
 echo ""
 echo "Invalid Option"
 echo ""
 sleep 3
}

function menu() {

    #Clears Screen
    clear

    #menu options
    echo " [1] Admin Menu"
    echo " [2] Security Menu"
    echo " [3] Exit"
    read -p "Plesae enter a choice above: " choice

    case "$choice" in
        1) admin_menu
        ;;
        2) security_menu
        ;;
        3) exit 0
        ;;
        *)
            invalid_opt
            #Calls the Main Menu
            menu
        ;;
    esac
}

function admin_menu() {
    #Clears Screen
    clear

    #admin menu options
    echo "[L]ist running Processes"
    echo "[N]etwork Sockets"
    echo "[V]PN Menu"
    echo "[4] Exit"
    read -p "Plesae enter a choice above: " choice

    case "$choice" in 
        L|l) ps -ef | less
        ;;
        N|n) netstat -an --inet | less
        ;;
        V|v) vpn_menu
        ;;
        4) exit 0
        ;;
        *)
            invalid_opt
            #Calls the Admin Menu
            admin_menu
        ;;
    esac
admin_menu
}

function vpn_menu() {
    #Clears Screen
    clear

    #vpn menu options
    echo "[A]dd a peer"
    echo "[D]elete a peer"
    echo "[B]ack to Admin Menu"
    echo "[M]ain Menu"
    echo "[E]xit"
    read -p "Plesae enter a choice above: " choice

    case "$choice" in
        A|a)
         bash peer.bash
         tail -6 wg0.conf | less
        ;;
        D|d)
        #Create a prompt for user
         #call the manage-user.bash and pass the proper swithes and arguemnts
         #delete user

        ;;
        B|b) admin_menu
        ;;
        M|m) menu
        ;;
        E|e) exit 0
        ;;
        *)
            invalid_opt
            #Calls the VPN Menu
            vpn_menu
        ;;
    esac
vpn_menu
}

function security_menu() {
    #Clears Screen
    clear

    #security menu options
    echo "[O]pen Network Sockets"
    echo "[U]id of 0"
    echo "[L]ast 10 log-Ins"
    echo "[C]urrent Logged In Users"
    echo "[B]lock List Menu"
    echo "[M]ain Menu"
    echo "[E]xit"
    read -p "Plesae enter a choice above: " choice

    case "$choice" in
        O|o) netstat -l | less
        ;;
        U|u) grep ":0:" /etc/passwd | cut -d: -f 6 | tr -d / | less
        ;;
        L|l) last | head -n 10 | less
        ;;
        C|c) w | less
        ;;
        B|b) block_list_menu
        ;;
        M|m) menu
        ;;
        E|e) exit 0
        ;;
        *)
            invalid_opt
            #Calls the Security Menu
            secuirty_menu
        ;;
    esac
security_menu
}

function block_list_menu() {
    #Clears Screen
    clear

    #Block List menu options
    echo "[I]Ptables"
    echo "[C]isco blocklist generator"
    echo "[D]omain URL blocklist Generator"
    echo "[W]indows blocklist generator"
    echo "[E]xit"
    read -p "Plesae enter a choice above: " choice

    case "$choice" in
        I|i) bash parse-threat.bash -i && sleep 2
        ;;
        C|c) bash parse-threat.bash -c && sleep 2
        ;;
        D|d) bash parse-threat.bash -p && sleep 2
        ;;
        W|w) bash parse-threat.bash -w && sleep 2
        ;;
        E|e) exit 0
        ;;
        *)
            invalid_opt
            #Calls the Block List Menu
            block_list_menu
        ;;
    esac
block_list_menu
}
menu
