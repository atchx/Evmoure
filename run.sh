#!/bin/bash
##############################################################
##                    COLORING YOUR SHELL                   ##
##############################################################
white="\033[1;37m"                                          ##
grey="\033[0;37m"                                           ##
purple="\033[0;35m"                                         ##
red="\e[91m"                                                ##
green="\e[92m"                                              ##
yellow="\e[93m"                                             ##
purple="\033[0;35m"                                         ##
cyan="\033[0;36m"                                           ##
cafe="\033[0;33m"                                           ##
fiuscha="\033[0;35m"                                        ##
blue="\033[1;34m"                                           ##
darkgrey="\e[100m"                                          ##
nc="\e[0m"                                                  ##
##############################################################
date=$(date +"%H:%M:%S")
fromlive=$(cat conf.php | grep '$mail->addAddress' | awk -F "'" '{printf $2}')
fromwarn=$(cat conf.php | grep '$mail->setFrom' | awk -F "'" '{printf $2}')
banner() {
    clear
    printf "${white}
      ___             __        __   ___
     |__  \  /  |\/| /  \ |  | |__) |__
     |___  \/   |  | \__/ \__/ |  \ |___

             i just love the way you are
             copyright © 2020 - ${green}mindbl0w${white}\n\n"
    printf "${green}[+]${white} Input SMTPS List : "
    read list
    printf "${green}[+]${white} Set Threads : "
    read threads
    printf "${green}[+]${white} Set Delay : "
    read delay
    echo ""
}
main() {
    if [[ $(ls | grep "conf.php") == "" ]]; then
        printf "${red} CAN'T FIND CONF.PHP\n EXITING..."
        sleep 2
        exit
    fi
}

banner
main
if [[ -f shitcount ]]; then
    rm shitcount
fi
if [[ -f livecount ]]; then
    rm livecount
fi
if [[ -f warncount ]]; then
    rm warncount
fi
touch shitcount
touch livecount
touch warncount
function testSend() {
    i="${1}"
    users=$(echo $i | awk -F '|' '{print $3}')
    babi=$(timeout $delay php conf.php "$i")
    if [[ $babi =~ "250 Great success" ]]; then
        echo "0" >> livecount
        printf "[${white}${green}$date${nc}${white}]-[${green}LIVE${white}]-[${green}$users${white}] SUCCESS SENT TO${green} $fromlive${white}\n"
    elif [[ $babi =~ "250 2.0.0 OK" ]]; then
        echo "0" >> livecount
        printf "[${white}${green}$date${nc}${white}]-[${green}LIVE${white}]-[${green}$users${white}] SUCCESS SENT TO${green} $fromlive${white}\n"
    elif [[ $babi =~ "250 2.0.0" ]]; then
        echo "0" >> livecount
        printf "[${white}${green}$date${nc}${white}]-[${green}LIVE${white}]-[${green}$users${white}] SUCCESS SENT TO${green} $fromlive${white}\n"
    elif [[ $babi =~ "mail accepted for delivery" ]]; then
        echo "0" >> livecount
        printf "[${white}${green}$date${nc}${white}]-[${green}LIVE${white}]-[${green}$users${white}] SUCCESS SENT TO${green} $fromlive${white}\n"
    elif [[ $babi =~ "Message accepted for delivery" ]]; then
        echo "0" >> livecount
        printf "[${white}${green}$date${nc}${white}]-[${green}LIVE${white}]-[${green}$users${white}] SUCCESS SENT TO${green} $fromlive${white}\n"
    elif [[ $babi =~ "554 The domain is unverified" ]]; then
        echo "0" >> warncount
        printf "[${white}${green}$date${nc}${white}]-[${yellow}WARN${white}]-[${green}$users${white}] FROM MAIL ${yellow}$fromwarn${white} NOT ACCEPTED, CHANGE THAT.${white}\n"
    elif [[ $babi =~ "Could not connect to SMTP host." ]]; then
        echo "0" >> shitcount
        printf "[${white}${green}$date${nc}${white}]-[${red}SHIT${white}]-[${green}$users${white}] SMTP HOST COULD NOT FOUND, ERROR${red} $fromlive${white}\n"
    elif [[ $babi =~ "SMTP connect() failed." ]]; then
        echo "0" >> shitcount
        printf "[${white}${green}$date${nc}${white}]-[${red}SHIT${white}]-[${green}$users${white}] CAN'T CONNECT TO HOST, ERROR${red} $fromlive${white}\n"
    elif [[ $babi =~ "554 Message rejected: Sending paused for this account." ]]; then
        echo "0" >> warncount
        printf "[${white}${green}$date${nc}${white}]-[${yellow}SHIT${white}]-[${green}$users${white}] AWS SMTP REJECTED EMAIL SENDING${yellow} $fromlive${white}\n"
   elif [[ $babi =~ "SERVER -> CLIENT: 250 OK id=" ]]; then
        echo "0" >> livecount
        printf "[${white}${green}$date${nc}${white}]-[${green}LIVE${white}]-[${green}$users${white}] SUCCESS SENT TO${green} $fromlive${white}\n"
   elif [[ $babi =~ "250 2.0.0 Ok: queued as" ]]; then
        echo "0" >> livecount
        printf "[${white}${green}$date${nc}${white}]-[${green}LIVE${white}]-[${green}$users${white}] SUCCESS SENT TO${green} $fromlive${white}\n"
    else
        echo "0" >> shitcount
        printf "[${white}${green}$date${nc}${white}]-[${red}SHIT${white}]-[${green}$users${white}] FAILED SENT TO${red} $fromlive${white}\n"
    fi
}
for i in $(cat $list); do
    ((cthread=cthread%threads)); ((cthread++==0)) && wait
    testSend "${i}" &
done
wait
printf "${green}----------------------- ${white}[FINISH]${green} -----------------------${white}\n"
countlive=$(grep -c "0" livecount)
countshit=$(grep -c "0" shitcount)
countwarn=$(grep -c "0" warncount)
printf "
+--------------------+
| ${green}LIVE${white} |${red} SHIT${white} | ${yellow}WARN${white} |
+------+------+------+
| $countlive    | $countshit    | $countwarn    |
+------+------+------+\n\n"
if [[ -f shitcount ]]; then
    rm shitcount
fi
if [[ -f livecount ]]; then
    rm livecount
fi
if [[ -f warncount ]]; then
    rm warncount
fi
exit
