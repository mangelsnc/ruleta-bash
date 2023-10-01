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
  echo -e "\t${blueColour}-t)${endColour} ${grayColour}Technique to play with ${endColour}${purpleColour}[martingala|inverse-labouchere]${endColour}"

  exit 1
}

function martingala() {
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Current money:${endColour} ${greenColour}$MONEY${endColour}"
  echo -ne "\n${yellowColour}[?]${endColour} ${grayColour}How much money do you want to bet? -> ${endColour}" && read INITIAL_BET
  echo -ne "${yellowColour}[?]${endColour} ${grayColour}What's your bet? [even|odd] -> ${endColour}" && read BET_TARGET

  echo -e "${yellowColour}[+]${endColour} ${grayColour}You are going to bet${endColour} ${blueColour}$INITIAL_BET${endColour} ${grayColour}to${endColour} ${blueColour}$BET_TARGET${endColour}\n"

  tput civis
  CURRENT_BET=$INITIAL_BET
  declare -i PLAY_COUNTER=1
  MAX_AMOUNT=$MONEY

  while true; do 
   
    if [ $MONEY -le 0 ]; then
      echo -e "\n\n${redColour}You run out of money. You lose.${endColour}\n\n";
      echo -e "${yellowColour}[+]${endColour} ${grayColour}You played a total of${endColour} ${blueColour}$PLAY_COUNTER${endColour} ${grayColour}times.${endColour}";
      echo -e "${yellowColour}[+]${endColour} ${grayColour}You earned a max amount${endColour} ${blueColour}$MAX_AMOUNT${endColour}\n";
      tput cnorm
      exit 0
    fi

    ROULETTE_NUMBER="$(($RANDOM % 37))"
    MONEY=$(($MONEY-$CURRENT_BET))
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}You have bet${endColour} ${blueColour}$CURRENT_BET${endColour}${grayColour}, now you have${endColour} ${blueColour}$MONEY${endColour}"
    echo -e "${yellowColour}[+]${endColour} ${grayColour}Number: ${endColour} ${blueColour}$ROULETTE_NUMBER${endColour}"

    if [ $ROULETTE_NUMBER -eq 0 ]; then
      echo -e "${redColour}[-] 0, you loose${endColour}\n"
      CURRENT_BET=$(($CURRENT_BET*2))
      sleep 0

      continue
    fi

    if [ "$BET_TARGET" == "even" ]; then
      if [ $(($ROULETTE_NUMBER % 2)) -eq 0 ]; then
        REWARD=$(($CURRENT_BET*2))
        MONEY=$(($MONEY+$REWARD))
        CURRENT_BET=$INITIAL_BET
        
        if [ $MONEY -gt $MAX_AMOUNT ]; then
          MAX_AMOUNT=$MONEY
        fi

        echo -e "${greenColour}[+] You win${endColour} ${blueColour}$REWARD${endColour}, ${grayColour}now you have${endColour} ${blueColour}$MONEY${endColour}\n"
      else  
        echo -e "${redColour}[-] You lose ${endColour}\n"
        CURRENT_BET=$(($CURRENT_BET*2))
      fi
    else
      if [ $(($ROULETTE_NUMBER % 2)) -eq 0 ]; then
        echo -e "${redColour}[-] You lose${endColour}\n"
        CURRENT_BET=$(($INITIAL_BET*2))
      else  
        REWARD=$(($CURRENT_BET*2))
        MONEY=$(($MONEY+$REWARD))
        CURRENT_BET=$INITIAL_BET
        
        if [ $MONEY -gt $MAX_AMOUNT ]; then
          MAX_AMOUNT=$MONEY
        fi

        echo -e "${greenColour}[+] You win ${endColour} ${blueColour}$REWARD${endColour}, ${grayColour}now you have${endColour} ${blueColour}$MONEY${endColour}\n"
      fi
    fi

    PLAY_COUNTER+=1
    sleep 0
  done

  tput cnorm
}

function inverse_labouchere() {
  echo -e "\n\n${purpleColour}INVERSE LABOUCHERE${endColour}\n\n"
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Current money:${endColour} ${greenColour}$MONEY${endColour}"
  echo -ne "\n${yellowColour}[?]${endColour} ${grayColour}How much money do you want to bet? -> ${endColour}" && read INITIAL_BET
  echo -ne "${yellowColour}[?]${endColour} ${grayColour}What's your bet? [even|odd] -> ${endColour}" && read BET_TARGET

  declare -a SEQUENCE=(1 2 3 4)

  echo -e "${yellowColour}[+]${endColour} ${grayColour}You are going to bet${endColour} ${blueColour}$INITIAL_BET${endColour} ${grayColour}to${endColour} ${blueColour}$BET_TARGET${endColour}\n"

  tput civis
  CURRENT_BET=$INITIAL_BET
  declare -i PLAY_COUNTER=1

  while true; do
    ROULETTE_NUMBER="$(($RANDOM % 37))"
    MONEY=$(($MONEY-$CURRENT_BET))

    if [ "$MONEY" -lt 0 ]; then
      echo -e "${redColour}\n[!] You run out of money${endColour}\n\n"
      tput cnorm
      exit 0
    fi

    echo -e "${yellowColour}[+]${endColour} ${grayColour}We bet${endColour} ${blueColour}$CURRENT_BET${endColour} ${grayColour}and the sequence is${endColour} ${blueColour}[${SEQUENCE[@]}]${endColour}"
    echo -e "${yellowColour}[+]${endColour} ${grayColour}Number:${endColour} ${blueColour}$ROULETTE_NUMBER${endColour}"
 
    if [ "$ROULETTE_NUMBER" -eq 0 ]; then
      echo -e "${redColour}[-] You lose!${endColour}"
      echo -e "${yellowColour}[+]${endColour} ${greenColour}Now you have${endColour} ${blueColour}$MONEY${endColour}\n"
      unset SEQUENCE[0]
      unset SEQUENCE[-1] 2>/dev/null
      SEQUENCE=(${SEQUENCE[@]})

      if [ "${#SEQUENCE[@]}" -eq 1 ]; then
        CURRENT_BET=${SEQUENCE[0]}
      elif [ "${#SEQUENCE[@]}" -gt 1 ]; then
        CURRENT_BET=$((${SEQUENCE[0]} + ${SEQUENCE[-1]}))
      else
        echo -e "${redColour}[!] Sequence finished${endColour}"
        SEQUENCE=(1 2 3 4)
        CURRENT_BET=$((${SEQUENCE[0]} + ${SEQUENCE[-1]}))
        echo -e "${yellowColour}[+]${endColour} ${grayColour}Restarting sequence to${endColour} ${blueColour}[${SEQUENCE[@]}]${endColour}...\n"
      fi

      continue
    fi

    if [ "$BET_TARGET" == "even" ]; then
      if [ "$(($ROULETTE_NUMBER % 2))" -eq 0 ]; then
        REWARD=$(($CURRENT_BET * 2))
        MONEY=$(($MONEY+$REWARD))
        SEQUENCE+=($CURRENT_BET)
        SEQUENCE=(${SEQUENCE[@]})
        
        if [ "${#SEQUENCE[@]}" -eq 1 ]; then
          CURRENT_BET=${SEQUENCE[0]}
        elif [ "${#SEQUENCE[@]}" -gt 1 ]; then
          CURRENT_BET=$((${SEQUENCE[0]} + ${SEQUENCE[-1]}))
        else
          echo -e "${redColour}[!] Sequence finished${endColour}"
          SEQUENCE=(1 2 3 4)
          CURRENT_BET=$((${SEQUENCE[0]} + ${SEQUENCE[-1]}))
          echo -e "${yellowColour}[+]${endColour} ${grayColour}Restarting sequence to${endColour} ${blueColour}[${SEQUENCE[@]}]${endColour}..."
        fi

        echo -e "${yellowColour}[+]${endColour} ${greenColour}You win!${endColour}"
        echo -e "${yellowColour}[+]${endColour} ${greenColour}Now you have${endColour} ${blueColour}$MONEY${endColour}\n"
      else
        echo -e "${redColour}[-] You lose!${endColour}"
        echo -e "${yellowColour}[+]${endColour} ${greenColour}Now you have${endColour} ${blueColour}$MONEY${endColour}\n"
        unset SEQUENCE[0]
        unset SEQUENCE[-1] 2>/dev/null
        SEQUENCE=(${SEQUENCE[@]})

        if [ "${#SEQUENCE[@]}" -eq 1 ]; then
          CURRENT_BET=${SEQUENCE[0]}
        elif [ "${#SEQUENCE[@]}" -gt 1 ]; then
          CURRENT_BET=$((${SEQUENCE[0]} + ${SEQUENCE[-1]}))
        else
          echo -e "${redColour}[!] Sequence finished${endColour}"
          SEQUENCE=(1 2 3 4)
          CURRENT_BET=$((${SEQUENCE[0]} + ${SEQUENCE[-1]}))
          echo -e "${yellowColour}[+]${endColour} ${grayColour}Restarting sequence to${endColour} ${blueColour}[${SEQUENCE[@]}]${endColour}...\n"
        fi                                                                        
      fi
    else
      if [ "$(($ROULETTE_NUMBER % 2))" -eq 0 ]; then
        echo -e "${redColour}[-] You lose!${endColour}"
        echo -e "${yellowColour}[+]${endColour} ${greenColour}Now you have${endColour} ${blueColour}$MONEY${endColour}\n"
        unset SEQUENCE[0]
        unset SEQUENCE[-1] 2>/dev/null
        SEQUENCE=(${SEQUENCE[@]})
        
        if [ "${#SEQUENCE[@]}" -eq 1 ]; then
          CURRENT_BET=$((${SEQUENCE[0]}))
        elif [ "${#SEQUENCE[@]}" -gt 1 ]; then
          CURRENT_BET=$((${SEQUENCE[0]} + ${SEQUENCE[-1]}))
        else
          echo -e "${redColour}[!] Sequence finished${endColour}"
          SEQUENCE=(1 2 3 4)
          CURRENT_BET=$((${SEQUENCE[0]} + ${SEQUENCE[-1]}))
          echo -e "${yellowColour}[+]${endColour} ${grayColour}Restarting sequence to${endColour} ${blueColour}[${SEQUENCE[@]}]${endColour}...\n"
        fi

      else
        REWARD=$(($CURRENT_BET * 2))
        MONEY=$(($MONEY+$REWARD))
        SEQUENCE+=($CURRENT_BET)
        SEQUENCE=(${SEQUENCE[@]})
        
        if [ "${#SEQUENCE[@]}" -eq 1 ]; then
          CURRENT_BET=$((${SEQUENCE[0]}))
        elif [ "${#SEQUENCE[@]}" -gt 1 ]; then
          CURRENT_BET=$((${SEQUENCE[0]} + ${SEQUENCE[-1]}))
        else
          echo -e "${redColour}[!] Sequence finished${endColour}"
          SEQUENCE=(1 2 3 4)
          CURRENT_BET=$((${SEQUENCE[0]} + ${SEQUENCE[-1]}))
          echo -e "${yellowColour}[+]${endColour} ${grayColour}Restarting sequence to${endColour} ${blueColour}[${SEQUENCE[@]}]${endColour}...\n"
        fi
       
        echo -e "${yellowColour}[+]${endColour} ${greenColour}You win!${endColour}"
        echo -e "${yellowColour}[+]${endColour} ${greenColour}Now you have${endColour} ${blueColour}$MONEY${endColour}\n"
      fi
    fi

    sleep 1
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
  elif [ "$TECHNIQUE" == "inverse-labouchere" ]; then
    inverse_labouchere
  else
    echo -e "\n${redColour}[!] Invalid technique \"$TECHNIQUE\"${endColour}"
    exit 1
  fi
else
  help_panel
fi
