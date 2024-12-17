#!/usr/bin/bash

# shellcheck disable=all
#Author: kaslmineer7999
#please check out the "LICENSE" file for license information
trap 'echo -en "\033[?1049l\033[?25h";exit 0' 2
timeoutafter="180"
playeravatar="\033[91mX\033[0m"
playerrow="2"
playercol="1"
playerscore="0"
pointavatar='\033[93m*\033[0m'
logo(){
	logo='
           _  __            __
          | |/ /   _________\ \     __/|_
          |   /   |__________\ \   |    /
          /   |   |__________/ /   /_ __|
         /_/|_|       Eat   /_/      |/

   _____ __             ______      __
  / ___// /_____ ______/ ____/___ _/ /____  _____
  \__ \/ __/ __ `/ ___/ __/ / __ `/ __/ _ \/ ___/
 ___/ / /_/ /_/ / /  / /___/ /_/ / /_/  __/ /
/____/\__/\__,_/_/  /_____/\__,_/\__/\___/_/


StarEater  Copyright (C) 2024  kaslmineer7999
This program comes with ABSOLUTELY NO WARRANTY
'

	stty -echo
	echo "$logo"
	sleep 1
	stty echo
	clear

}
pointup(){
	pointrow="$(($RANDOM%`tput lines`))"
	pointcol="$(($RANDOM%`tput cols`))"
	[ "$pointrow" -le "2" ] && pointrow="$(($pointrow+3))"
	[ "$pointrow" -le "-1" ] && pointrow="$(($pointrow- $pointrow+1))"
	[ "$1" = "noscore" ] || {
		((playerscore++))
		clear
		echo -en "score: $playerscore\033[$pointrow;${pointcol}H$pointavatar\033[$playerrow;${playercol}H$playeravatar"
	}
}
echo -en "\033[?1049h\033[?25l"
clear
logo
pointup noscore
echo -en "score: $playerscore\033[$pointrow;${pointcol}H$pointavatar\033[$playerrow;${playercol}H$playeravatar"
{
	sleep $timeoutafter
	echo -e "\033[?1049l\033[?25hyou timedout."
	kill -9 $$ 2>/dev/null 1>&2
} &
while [ 1 ]
do
	{ [ "$playerrow" = "$pointrow" ] && [ "$playercol" = "$pointcol" ]; } && pointup
	read -sn1 key
	case "$key" in
		w|W)
			clear
			((playerrow--))
			[ "$playerrow" -le "2" ] && playerrow="2"
			echo -en "score: $playerscore\033[$pointrow;${pointcol}H$pointavatar\033[$playerrow;${playercol}H$playeravatar"
			;;
		s|S)
			clear
			((playerrow++))
			[ "$playerrow" -gt "`tput lines`" ] && playerrow="`tput lines`"
			echo -en "score: $playerscore\033[$pointrow;${pointcol}H$pointavatar\033[$playerrow;${playercol}H$playeravatar"
			;;
		a|A)
			clear
			((playercol--))
			[ "$playercol" -le "0" ] && playercol="1"
			echo -en "score: $playerscore\033[$pointrow;${pointcol}H$pointavatar\033[$playerrow;${playercol}H$playeravatar"
			;;
		d|D)
			clear
			((playercol++))
			[ "$playercol" -gt "`tput cols`" ] && playercol="`tput cols`"
			echo -en "score: $playerscore\033[$pointrow;${pointcol}H$pointavatar\033[$playerrow;${playercol}H$playeravatar"
			;;
	esac
done
