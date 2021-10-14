#!/bin/bash

#Storyline: Open Video

#Link if script fails: https://champlain.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=920e84ce-e7b5-4f97-bf3a-adb50171360c

link=https://champlain.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=292cff96-964a-44a7-aefa-adc1014f958a
function open_video() {
    #Clears Screen
    clear

    #security menu options
    echo "What OS are you using? [w|Windows][l|Linux][m|MacOs]"
    echo "[W]indows"
    echo "[L]inux"
    echo "[M]acOs"
    echo "[E]xit"
    read -p "Plesae enter a choice above: " choice

    case "$choice" in
        W|w) start ${link}
        ;;
        L|l) xdg-open ${link}
        ;;
        M|m) open ${link}
        ;;
        E|e) exit 0
        ;;
        *)
            invalid_opt
            #Calls the Video Menu
            open_video
        ;;
    esac
open_video
}
open_video
