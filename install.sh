

#!/usr/bin/env sh
show_menu(){

    green='\033[0;32m'
    normal=`echo "\033[m"`
    menu=`echo "\033[36m"` #Blue
    number=`echo "\033[33m"` #yellow
    bgred=`echo "\033[41m"`
    fgred=`echo "\033[31m"`

    printf "${green}****************************************************************************\n"
    printf "*                             Demo Software LTD.                                *\n"
    printf "*                ${green}Software-Installation Version 1.0 (08/2025)               *\n"
    printf "*                  https://local.com | support@local.com                      *\n"
    printf "*        Please conatct with IT Department before using this script        *\n"
    printf "${green}****************************************************************************\n"

    printf "${menu}${number} 1)${menu} Install Software ${normal}\n"
    printf "${menu}${number} 2)${menu} Destroy Software ${normal}\n"
    printf "${menu}${number} 3)${menu} Curent Configuration ${normal}\n"
    printf "\n"
    printf "Please enter a menu option and enter or ${fgred}0 to exit ${normal}:\n"
    read opt
}

option_picked(){
    msgcolor=`echo "\033[01;31m"` # bold red
    normal=`echo "\033[00;00m"` # normal white
    message=${@:-"${normal}Error: No message passed"}
    printf "${msgcolor}${message}${normal}\n"
}

clear
show_menu
while [ $opt != '' ]
    do sleep 1
    if [ $opt = '0' ]; then
      exit;
    else
      case $opt in
        1) clear;
            option_picked "Install Software";
            terraform init || exit 1
            terraform validate || exit 1
            terraform apply -var-file="template.tfvars" -auto-approve && 
            terraform -chdir=modules/ingress/ init
            terraform -chdir=modules/ingress/ apply -auto-approv &&
            terraform -chdir=modules/app/ init
            terraform -chdir=modules/app/ apply -auto-approve
            exit;
        ;;
        2) clear;
            option_picked "Destroy Software";
            terraform destroy -var-file="template.tfvars" -auto-approve
            exit;
        ;;
        3) clear;
            option_picked "Current Configuration";
            kubectl cluster-info && sleep 2
            echo -e "Collecting Information of the memory:\e" && sleep 2
            kubectl top nodes | grep -v MEMORY% && sleep 2
            echo -e "Get Information of the nodes:\e" && sleep 2
            kubectl get nodes -o wide && sleep 2
            echo -e "Get Information of the services:\e" && sleep 2
            kubectl get svc -A && sleep 2
            echo -e "Get Running pods:\e" && sleep 2
            kubectl get pods -A && sleep 2
            echo -e "Configuration is okey:\e"
            exit;
        ;;
      esac
    fi
done
