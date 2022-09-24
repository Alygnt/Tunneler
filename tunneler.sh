RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
YELLOW="$(printf '\033[33m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"
RESETBG="$(printf '\e[0m\n')"
NC='\033[0m' # No Color

#Directories
pro_dir=$(pwd)

banner(){
echo -e "${YELLOW} ▀▀█▀▀ █░░█ █▀▀▄ █▀▀▄ █▀▀ █░░ █▀▀ █▀▀█${NC}"
echo -e "${YELLOW} ░▒█░░ █░░█ █░░█ █░░█ █▀▀ █░░ █▀▀ █▄▄▀${NC}"
echo -e "${YELLOW} ░▒█░░ ░▀▀▀ ▀░░▀ ▀░░▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀░▀▀${NC}"
}


credits_banner(){
echo -e "${YELLOW} ▀▀█▀▀ █░░█ █▀▀▄ █▀▀▄ █▀▀ █░░ █▀▀ █▀▀█${NC}"
echo -e "${YELLOW} ░▒█░░ █░░█ █░░█ █░░█ █▀▀ █░░ █▀▀ █▄▄▀${NC}"
echo -e "${YELLOW} ░▒█░░ ░▀▀▀ ▀░░▀ ▀░░▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀░▀▀${NC}"
echo -e "${CYAN}                                -Alygnt ${NC}"
echo -e "${WHITE}         ${NC}"
echo -e "${WHITE}                 Version 1.1       ${NC}"
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

## Download Ngrok old
install_ngrok_old() {
        if [[ -e "$HOME/ngrok" ]]; then
                echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Ngrok already installed."
        else
                echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing ngrok..."${WHITE}
                arch=`uname -m`
                if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
                        download 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip' 'ngrok'
                elif [[ "$arch" == *'aarch64'* ]]; then
                        download 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.zip' 'ngrok'
                elif [[ "$arch" == *'x86_64'* ]]; then
                        download 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip' 'ngrok'
                else
                        download 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip' 'ngrok'
                fi
        fi
        ngrok_token_check
}

## Install ngrok
install_ngrok() {
	if [[ -e ".server/ngrok" ]]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Ngrok already installed."
	else
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing ngrok..."${WHITE}
		arch=`uname -m`
		if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
			download 'https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.tgz' 'ngrok'
		elif [[ "$arch" == *'aarch64'* ]]; then
			download 'https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz' 'ngrok'
		elif [[ "$arch" == *'x86_64'* ]]; then
			download 'https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz' 'ngrok'
		else
			download 'https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-386.tgz' 'ngrok'
		fi
	fi
	ngrok_token_check
}


##Ngrok token auth
ngrok_token_check(){
	if [ -s "${HOME}/.ngrok2/ngrok.yml" ]; then
		echo -e "\n${GREEN}[${WHITE}#${GREEN}]${GREEN} Ngrok Authtoken setup is already done."
		read -p "${RED}[${WHITE}-${RED}]${GREEN} DO YOU WANT TO CHANGE THE TOKEN (Y/N) : ${BLUE}" ntr
		case $ntr in
	       	      Y | y)
	     	        ngrok_token_setup;;
	              N | n)
	               echo -e "\n${GREEN}[${WHITE}#${GREEN}]${GREEN} Using Old ngrok token"
		       clear
		       msg_exit;;
	              *)
			echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
			sleep 2
			banner
			ngrok_token_check;;
		esac
	else
                echo -e "\n${GREEN}[${WHITE}#${GREEN}]${GREEN} Setting up authtoken"
                ngrok_token_setup
        fi
}

ngrok_token_setup(){
	if [[ -d "${HOME}/.ngrok2/" ]]; then
	       echo -e "\n${GREEN}[${WHITE}#${GREEN}]${GREEN} Ngrok2 directory exists!!"
	else
	       mkdir $HOME/.ngrok2
	       echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Created Ngrok2 directory "
	fi

	if [[ -s "${HOME}/.ngrok2/ngrok.yml" ]]; then
	       rm -rf ${HOME}/.ngrok2/ngrok.yml
	       echo -e "\n"
	       read -p "${RED}[${WHITE}-${RED}]${GREEN} Enter your authtoken :" ntoken
	       authline="authtoken : ${ntoken}"
	       echo "$authline" >> ngrok.yml
	       mv ngrok.yml ${HOME}/.ngrok2/
	else
               read -p "${RED}[${WHITE}-${RED}]${GREEN} Enter your authtoken :" ntoken
	       echo "authtoken : ${ntoken}" >> ngrok.yml
	       mv ngrok.yml ${HOME}/.ngrok2/
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
		banner
		ngrok_token_check
	fi
}


## Install Cloudflared
install_cloudflared() {
	if [[ -e ".server/cloudflared" ]]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Cloudflared already installed."
	else
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing Cloudflared..."${WHITE}
		arch=`uname -m`
		if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
			download 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm' 'cloudflared'
		elif [[ "$arch" == *'aarch64'* ]]; then
			download 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64' 'cloudflared'
		elif [[ "$arch" == *'x86_64'* ]]; then
			download 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64' 'cloudflared'
		else
			download 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386' 'cloudflared'
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

## Install LocalXpose
install_localxpose() {
	if [[ -e ".server/loclx" ]]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} LocalXpose already installed."
	else
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing LocalXpose..."${WHITE}
		arch=`uname -m`
		if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
			download 'https://api.localxpose.io/api/v2/downloads/loclx-linux-arm.zip' 'loclx'
		elif [[ "$arch" == *'aarch64'* ]]; then
			download 'https://api.localxpose.io/api/v2/downloads/loclx-linux-arm64.zip' 'loclx'
		elif [[ "$arch" == *'x86_64'* ]]; then
			download 'https://api.localxpose.io/api/v2/downloads/loclx-linux-amd64.zip' 'loclx'
		else
			download 'https://api.localxpose.io/api/v2/downloads/loclx-linux-386.zip' 'loclx'
		fi
	fi
	auth_localxpose
}
auth_localxpose() {
	./.server/loclx -help > /dev/null 2>&1 &
	sleep 1
	[ -d ".localxpose" ] && auth_f=".localxpose/.access" || auth_f="$HOME/.localxpose/.access" 

	[ "$(./.server/loclx account status | grep Error)" ] && {
		echo -e "\n\n${RED}[${WHITE}!${RED}]${GREEN} Create an account on ${ORANGE}localxpose.io${GREEN} & copy the token\n"
		sleep 3
		read -p "${RED}[${WHITE}-${RED}]${ORANGE} Loclx Token :${ORANGE} " loclx_token
		[[ $loclx_token == "" ]] && {
			echo -e "\n${RED}[${WHITE}!${RED}]${RED} You have to input Localxpose Token." ; sleep 2 ; choice
		} || {
			echo -n "$loclx_token" > $auth_f 2> /dev/null
		}
	}
}

# Download Binaries
download() {
	url="$1"
	output="$2"
	file=`basename $url`
	if [[ -e "$file" || -e "$output" ]]; then
		rm -rf "$file" "$output"
	fi
	curl --silent --insecure --fail --retry-connrefused \
		--retry 3 --retry-delay 2 --location --output "${file}" "${url}"

	if [[ -e "$file" ]]; then
		if [[ ${file#*.} == "zip" ]]; then
			unzip -qq $file > /dev/null 2>&1
			mv -f $output .server/$output > /dev/null 2>&1
		elif [[ ${file#*.} == "tgz" ]]; then
			tar -zxf $file > /dev/null 2>&1
			mv -f $output .server/$output > /dev/null 2>&1
		else
			mv -f $file .server/$output > /dev/null 2>&1
		fi
		chmod +x .server/$output > /dev/null 2>&1
		rm -rf "$file"
	else
		echo -e "\n${RED}[${WHITE}!${RED}]${RED} Error occured while downloading ${output}."
		{ reset_color; exit 1; }
	fi
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
echo -e "${GREEN} 7. LOCALXPOSE ${NC}"
echo -e "${GREEN} 0. Exit ${NC}"
echo -e "${BLUE} ${NC}"
read -p " ${ORANGE} Enter a choice 1/2/3/4/5/6/0 : " choice
echo ' '
case $choice in
	1 | 01 )
		install_ngrok_old;;
	2 | 02)
		install_ngrok;;
	3 | 03)
                install_ngrok_advanced;;
	4 | 04)
		install_cloudflared;;
	5 | 05)
		install_openssh;;
	6 | 06)
		install_apache2;;
	7 | 07)
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

