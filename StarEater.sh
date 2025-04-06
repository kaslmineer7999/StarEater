#!/usr/bin/bash

# shellcheck disable=all
#Author: kaslmineer7999
#please check out the "LICENSE" file for license information
trap 'printf "\033[?1049l\033[?25h";exit 0' 2
timeoutafter="180"
playeravatar="\033[91mX\033[0m"
playerrow="2"
playercol="1"
playerscore="0"
pointavatar='\033[93m*\033[0m'
printscreen(){ printf "\033[0;0Hscore: $playerscore\033[0;$((`tput cols`-(13+${#timeoutafterctr})))Htime left: `</tmp/timeoutafterctr`\033[$pointrow;${pointcol}H$pointavatar\033[$playerrow;${playercol}H$playeravatar"; }
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
		printscreen
	}
}
printf "\033[?1049h\033[?25l"
clear
logo
{
	trap 'exit' 2
	timeoutafterctr="$timeoutafter"
	while [ "$timeoutafterctr" -ne "0" ]
	do
		printf "\033[0;$((`tput cols`-(10+${#timeoutafterctr})))Htime left: $timeoutafterctr"
		printf "$timeoutafterctr" > /tmp/timeoutafterctr
		sleep 1
		timeoutafterctr="$(($timeoutafterctr-1))"
	done
	printf "\033[?1049l\033[?25hyou timedout.\n"
	kill -9 $$ 2>/dev/null 1>&2
} &
pointup noscore
printscreen
while [ 1 ]
do
	{ [ "$playerrow" = "$pointrow" ] && [ "$playercol" = "$pointcol" ]; } && pointup
	read -sn1 key
	case "$key" in
		w|W)
			((playerrow--))
			[ "$playerrow" -le "2" ] && playerrow="2"
			clear
			printscreen
			;;
		s|S)
			((playerrow++))
			[ "$playerrow" -gt "`tput lines`" ] && playerrow="`tput lines`"
			clear
			printscreen
			;;
		a|A)
			((playercol--))
			[ "$playercol" -le "0" ] && playercol="1"
			clear
			printscreen
			;;
		d|D)
			((playercol++))
			[ "$playercol" -gt "`tput cols`" ] && playercol="`tput cols`"
			clear
			printscreen
			;;
	esac
done
