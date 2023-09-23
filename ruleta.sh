#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c() {
  echo -e "\n${redColour}[!] Closing...${endColour}\n"
  tput cnorm
  exit 1
}

trap ctrl_c INT

function help_panel() {
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Usage: $0${endColour}\n"
  echo -e "\t${blueColour}-m)${endColour} ${grayColour}Amount of money to play with${endColour}"
  echo -e "\t${blueColour}-t)${endColour} ${grayColour}Technique to play with ${endColour}${purpleColour}[martingala|inverse-labrouchere]${endColour}"

  exit 1
}

function martingala() {
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Current money:${endColour} ${greenColour}$MONEY${endColour}"
  echo -ne "\n${yellowColour}[?]${endColour} ${grayColour}How much money do you want to bet? -> ${endColour}" && read INITIAL_BET
  echo -ne "${yellowColour}[?]${endColour} ${grayColour}What's your bet? [even|odd] -> ${endColour}" && read BET_TARGET

  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}You are going to bet${endColour} ${blueColour}$INITIAL_BET${endColour} ${grayColour}to${endColour} ${blueColour}$BET_TARGET${endColour}"

  tput civis
  while true; do 
    ROULETTE_NUMBER="$(($RANDOM % 37))"

    echo -e "${yellowColour}[+]${endColour} ${grayColour}Number: ${endColour} ${blueColour}$ROULETTE_NUMBER${endColour}"
    
    if [ $ROULETTE_NUMBER -eq 0 ]; then
      echo -e "${redColour}[-] 0, you loose${endColour}\n"
      continue
    fi

    if [ $(($ROULETTE_NUMBER % 2)) -eq 0 ]; then
      echo -e "${yellowColour}[+] Even${endColour}\n"
    else  
      echo -e "${yellowColour}[+] Odd${endColour}\n"
    fi

    sleep 0.4
  done

  tput cnorm
}

while getopts "m:t:h" ARG; do
  case $ARG in
    m) MONEY=$OPTARG;;
    t) TECHNIQUE=$OPTARG;;
    h) help_panel;;
  esac
done

if [ $MONEY ] && [ $TECHNIQUE ] ; then
  if [ "$TECHNIQUE" == "martingala" ]; then
    martingala
  else
    echo -e "\n${redColour}[!] Invalid technique \"$TECHNIQUE\"${endColour}"
    exit 1
  fi
else
  help_panel
fi
