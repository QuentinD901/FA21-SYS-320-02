#!/bin/bash

#Storyline: Open Video

#Link if script fails: https://champlain.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=75b017da-88bc-4232-8ed4-adb20186846b

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
        W|w) start https://champlain.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=75b017da-88bc-4232-8ed4-adb20186846b
        ;;
        L|l) xdg-open https://champlain.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=75b017da-88bc-4232-8ed4-adb20186846b
        ;;
        M|m) open https://champlain.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=75b017da-88bc-4232-8ed4-adb20186846b

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
