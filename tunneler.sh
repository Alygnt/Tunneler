RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
YELLOW="$(printf '\033[33m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"
RESETBG="$(printf '\e[0m\n')"
NC='\033[0m' # No Color

banner(){
echo -e "${YELLOW} ▀▀█▀▀ █░░█ █▀▀▄ █▀▀▄ █▀▀ █░░ █▀▀ █▀▀█${NC}"
echo -e "${YELLOW} ░▒█░░ █░░█ █░░█ █░░█ █▀▀ █░░ █▀▀ █▄▄▀${NC}"
echo -e "${YELLOW} ░▒█░░ ░▀▀▀ ▀░░▀ ▀░░▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀░▀▀${NC}"
}


credits_banner(){
echo -e "${YELLOW} ▀▀█▀▀ █░░█ █▀▀▄ █▀▀▄ █▀▀ █░░ █▀▀ █▀▀█${NC}"
echo -e "${YELLOW} ░▒█░░ █░░█ █░░█ █░░█ █▀▀ █░░ █▀▀ █▄▄▀${NC}"
echo -e "${YELLOW} ░▒█░░ ░▀▀▀ ▀░░▀ ▀░░▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀░▀▀${NC}"
echo -e "${CYAN}                                -RDXLR ${NC}"
echo -e "${WHITE}         ${NC}"
echo -e "${WHITE}                 Version 1.0       ${NC}"
}

#Dependencies
dependencies() {
        echo -e "\n${GREEN}[${WHITE}#${GREEN}]${CYAN} Installing required packages..."

        if [[ `command -v wget` &&  `command -v unzip` ]]; then
                echo -e "\n${GREEN}[${WHITE}#${GREEN}]${GREEN} Packages already installed."
        else
                pkgs=(curl unzip)
                for pkg in "${pkgs[@]}"; do
                        type -p "$pkg" &>/dev/null || {
                                echo -e "\n${GREEN}[${WHITE}#${GREEN}]${CYAN} Installing package : ${ORANGE}$pkg${CYAN}"${WHITE}
                                if [[ `command -v pkg` ]]; then
                                        pkg install "$pkg" -y
                                elif [[ `command -v apt` ]]; then
                                        apt install "$pkg" -y
                                elif [[ `command -v apt-get` ]]; then
                                        apt-get install "$pkg" -y
                                elif [[ `command -v pacman` ]]; then
                                        sudo pacman -S "$pkg" --noconfirm
                                elif [[ `command -v dnf` ]]; then
                                        sudo dnf -y install "$pkg"
                                else
                                        echo -e "\n${RED}[${WHITE}!${RED}]${RED} Unsupported package manager, Install packages manually."
                                        { reset_color; exit 1; }
                                fi
                        }
                done
        fi

}

## Reset terminal colors
reset_color() {
        tput sgr0   # reset attributes
        tput op     # reset color
    return
}

#check whether execute permission is granted
xpermission(){
	if [ -x "tunneler.sh" ];then
		echo -e "\n${GREEN}[${WHITE}#${GREEN}]${GREEN} Execute Permission Granted!!"
	else
	        chmod 777 tunneler.sh
		echo -e "\n${GREEN}[${WHITE}#${GREEN}]${GREEN} Execute Permission Granted!!"
	fi
}

## Download Ngrok
download_ngrok() {
        url="$1"
        file=`basename $url`
        if [[ -e "$file" ]]; then
                rm -rf "$file"
        fi
        wget --no-check-certificate "$url" > /dev/null 2>&1
        if [[ -e "$file" ]]; then
                unzip "$file" > /dev/null 2>&1
                mv -f ngrok /ngrok > /dev/null 2>&1
                rm -rf "$file" > /dev/null 2>&1
                chmod +x /ngrok > /dev/null 2>&1
		mv ngrok $HOME > /dev/null 2>&1
        else
                echo -e "\n${RED}[${WHITE}!${RED}]${RED} Error occured, Install Ngrok manually."
                { reset_color; exit 1; }
        fi
	msg_exit
}
install_ngrok() {
        if [[ -e "$HOME/ngrok" ]]; then
                echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Ngrok already installed."
        else
                echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing ngrok..."${WHITE}
                arch=`uname -m`
                if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
                        download_ngrok 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip'
                elif [[ "$arch" == *'aarch64'* ]]; then
                        download_ngrok 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.zip'
                elif [[ "$arch" == *'x86_64'* ]]; then
                        download_ngrok 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip'
                else
                        download_ngrok 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip'
                fi
        fi

}

## Download Ngrok latest
download_ngrok_lat() {
        url="$1"
        file=`basename $url`
        if [[ -e "$file" ]]; then
                rm -rf "$file"
        fi
        wget --no-check-certificate "$url" > /dev/null 2>&1
        if [[ -e "$file" ]]; then
                tar xvzf "$file" > /dev/null 2>&1
                mv -f ngrok .server > /dev/null 2>&1
                rm -rf "$file" > /dev/null 2>&1
                chmod +x .server/ngrok > /dev/null 2>&1
		mv ngrok $HOME > /dev/null 2>&1
        else
                echo -e "\n${RED}[${WHITE}!${RED}]${RED} Error occured, Install Ngrok manually."
                { reset_color; exit 1; }
        fi
	msg_exit
}
install_ngrok_lat() {
        if [[ -e "$HOME/ngrok" ]]; then
                echo -e "\n${GREEN}[${WHITE}#${GREEN}]${GREEN} Ngrok already installed."
        else
                echo -e "\n${GREEN}[${WHITE}#${GREEN}]${CYAN} Installing ngrok..."${WHITE}
                arch=`uname -m`
                if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
                        download_ngrok_lat 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.tgz'
                elif [[ "$arch" == *'aarch64'* ]]; then
                        download_ngrok_lat 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.tgz'
                elif [[ "$arch" == *'x86_64'* ]]; then
                        download_ngrok_lat 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.tgz'
                else
                        download_ngrok_lat 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.tgz'
                fi
        fi

}

##Install ngrok advanced
install_ngrok_advanced(){
	if [[ -e "$HOME/ngrok" ]]; then
                echo -e "\n${GREEN}[${WHITE}#${GREEN}]${GREEN} Ngrok already installed."
        else
                echo -e "\n${GREEN}[${WHITE}#${GREEN}]${CYAN} Installing ngrok..."${WHITE}
		wget --no-check-certificate https://bin.equinox.io/a/nmkK3DkqZEB/ngrok-2.2.8-linux-arm64.zip
		unzip ngrok-2.2.8-linux-arm64.zip
		chmod +x ngrok
		rm -rf ngrok-2.2.8-linux-arm64.zip
		mv ngrok $HOME > /dev/null 2>&1
		clear
		msg_exit
	fi
}


## Download Cloudflared
download_cloudflared() {
        url="$1"
        file=`basename $url`
        if [[ -e "$file" ]]; then
                rm -rf "$file"
        fi
        wget -o cloudflared --no-check-certificate "$url" > /dev/null 2>&1
        if [[ -e "$file" ]]; then
                chmod +x cloudflared > /dev/null 2>&1
		mv cloudflared $HOME > /dev/null 2>&1
        else
                echo -e "\n${RED}[${WHITE}!${RED}]${RED} Error occured, Install Cloudflared manually."
                { reset_color; exit 1; }
        fi
	msg_exit
}
install_cloudflared() {
        if [[ -e "$HOME/cloudflared" ]]; then
                echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Cloudflared already installed."
        else
                echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing Cloudflared..."${WHITE}
                arch=`uname -m`
                if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
                        download_cloudflared 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm'
                elif [[ "$arch" == *'aarch64'* ]]; then
                        download_cloudflared 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64'
                elif [[ "$arch" == *'x86_64'* ]]; then
                        download_cloudflared 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64'
                else
                        download_cloudflared 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386'
                fi
        fi

}

#Download Openssh
install_openssh(){
	echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing Openssh..."${WHITE}
	sleep 1
	apt install openssh -y
	echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installed/Updated Openssh..."${WHITE}
	sleep 1
	msg_exit
}

#Download Apache2
install_apache2() {
	echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing apache2..."${WHITE}
	sleep 1
	apt-get install apache2 -y
	echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installed/Updated apache2..."${WHITE}
	echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} To start apache2 server at http://127.0.0.1:8080 , type 'apachectl -k start'"${WHITE}
	sleep 5
        msg_exit
}

choice() {
echo -e "${BLUE} ${NC}"
echo -e "${BLUE} ${NC}"
echo -e "${BLUE} CHOOSE WHAT YOU WANT TO ${NC}"
echo -e "${BLUE} ${NC}"
echo -e "${GREEN} 1. NGROK old (zip file)${NC}"
echo -e "${GREEN} 2. NGROK new (tar file)${NC}"
echo -e "${GREEN} 3. NGROK advanced (for mobile/termux users) ${NC}"
echo -e "${GREEN} 4. CLOUDFLARED ${NC}"
echo -e "${GREEN} 5. OPENSSH ${NC}"
echo -e "${GREEN} 6. APACHE2 ${NC}"
echo -e "${GREEN} 0. Exit ${NC}"
echo -e "${BLUE} ${NC}"
read -p " ${ORANGE} Enter a choice 1/2/3/4/5/6/0 : " choice
echo ' '
case $choice in
	1 | 01 )
		install_ngrok;;
	2 | 02)
		install_ngrok_lat;;
	3 | 03)
                install_ngrok_advanced;;
	4 | 04)
		install_cloudflared;;
	5 | 05)
		install_openssh;;
	6 | 06)
		install_apache2;;
	0)
		msg_exit;;
	*)
		clear
		banner
		echo -e "${RED} INCORRECT/INVALID OPTION (${choice}) TRY AGAIN ${NC}"
		sleep 2
		clear
		credits_banner
		choice;;
esac
}

msg_exit() {
        { clear; credits_banner; echo; }
        echo -e "${GREENBG}${BLACK} Thank you for using this tool. Have a good day.${RESETBG}\n"
        { reset_color; exit 0; }
}


#MAIN
clear
credits_banner
sleep 1
dependencies
sleep 1
clear
echo " "
echo " "
credits_banner
choice
